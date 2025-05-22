import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/utils/util.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = ""; 
  String get endpoint => _endpoint;

  static String? get baseUrl => _baseUrl;

  BaseProvider(String endpointParam) {
    _endpoint = endpointParam;
    _baseUrl ??= const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5115/");
  }

  Future<SearchResult<T>> get(
      {dynamic filter, String? endpointOverride}) async {
    var usedEndpoint = endpointOverride ?? _endpoint;
    var url = "$_baseUrl$usedEndpoint";

    if (filter != null) {
      final queryParams = filter is Map ? filter : filter.toJson();
      var queryString = getQueryString(queryParams);
      url = url.contains('?') ? "$url&$queryString" : "$url?$queryString";
    }
    if (kDebugMode) {
      print('Request URL: $url');
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.get(uri, headers: headers);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print('Pagination response data structure: ${data.keys.join(', ')}');
        }

        var result = SearchResult<T>();
        result.count = data['totalCount'] as int? ?? 0;
        print('Total Count: ${result.count}');

        var items = data['items'] as List? ?? [];
        if (kDebugMode) {
          print('Number of items received: ${items.length}');
        }
        result.result = items.map((item) {
          try {
            return fromJson(item);
          } catch (e) {
            if (kDebugMode) print('Error mapping item: $item Error: $e');
            rethrow;
          }
        }).toList();

        return result;
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in BaseProvider.get for $usedEndpoint: $e');
      }
      rethrow;
    }
  }

  Future<List<T>> getAll(
      {String? endpointOverride,
      Map<String, dynamic>? queryParameters,
      bool skipEndpointAppend = false}) async {
    var url = "$_baseUrl";

    if (skipEndpointAppend) {
      url = endpointOverride != null ? "$url$endpointOverride" : url;
    } else {
      url = "$url$_endpoint";
      if (endpointOverride != null) {
        url = url.endsWith('/')
            ? "$url${endpointOverride.startsWith('/') ? endpointOverride.substring(1) : endpointOverride}"
            : "$url/${endpointOverride.startsWith('/') ? endpointOverride.substring(1) : endpointOverride}";
      }
    }

    if (queryParameters != null) {
      var queryString = getQueryString(queryParameters);
      url = url.contains('?') ? "$url&$queryString" : "$url?$queryString";
    }

    if (kDebugMode) {
      print('Request URL (getAll): $url');
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.get(uri, headers: headers);
      if (kDebugMode) {
        print('Response status (getAll): ${response.statusCode}');
        print('Response body (getAll): ${response.body}');
      }

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);

        if (data is! List) {
          throw Exception(
              "API response format mismatch. Expected a list for getAll.");
        }

        if (kDebugMode) {
          print('Number of items received (getAll): ${data.length}');
        }

        final List<T> resultList = data.map((itemJson) {
          try {
            return fromJson(itemJson);
          } catch (e) {
            if (kDebugMode)
              print('Error mapping item in getAll: $itemJson Error: $e');
            rethrow;
          }
        }).toList();

        return resultList;
      } else {
        throw Exception("Failed to load data (getAll): ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in BaseProvider.getAll for $url: $e');
      }
      rethrow;
    }
  }

  Future<T> getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);
    if (kDebugMode) {
      print(response.body);
    }
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> put(
      {required String endpointOverride, required dynamic request}) async {
    var url =
        "$_baseUrl$_endpoint/${endpointOverride.startsWith('/') ? endpointOverride.substring(1) : endpointOverride}";

    if (kDebugMode) {
      print('Request URL (put custom): $url');
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    if (kDebugMode) {
      print('Request body (put custom): $jsonRequest');
    }

    try {
      var response = await http.put(uri, headers: headers, body: jsonRequest);

      if (kDebugMode) {
        print('Response status (put custom): ${response.statusCode}');
        print('Response body (put custom): ${response.body}');
      }

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        throw Exception(
            "Failed to complete PUT request: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in BaseProvider.put custom for $url: $e');
      }
      rethrow;
    }
  }

  Future<bool> delete(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (isValidResponse(response)) {
      return true;
    } else {
      throw Exception("Unknown error");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorised");
    } else {
      throw Exception("Something went wrong");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}