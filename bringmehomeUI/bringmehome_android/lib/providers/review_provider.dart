import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:learning_app/models/reviews.dart';
import 'package:learning_app/models/search_objects/review_search_object.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("api/Review");

  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }

  Future<Map<String, String>> _createAuthHeaders() async {
    final token = await AuthService.getAccessToken();
    var headers = {
      "Content-Type": "application/json",
    };
    
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    
    return headers;
  }

  Future<SearchResult<Review>> search(ReviewSearchObject searchObject) async {
    try {
      var url = "${BaseProvider.baseUrl}$endpoint";
      
      final queryParams = searchObject.toJson();
      var queryString = getQueryString(queryParams);
      url = url.contains('?') ? "$url&$queryString" : "$url?$queryString";
    
      if (kDebugMode) {
        print('Request URL: $url');
      }

      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

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

        var result = SearchResult<Review>();
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
        print('Error in ReviewProvider.search: $e');
      }
      rethrow;
    }
  }

  Future<Review> createReview({
    required int userId,
    required int shelterId,
    required int rating,
    required String comment,
  }) async {
    try {
      final requestData = {
        'userID': userId,
        'shelterID': shelterId,
        'rating': rating,
        'comment': comment,
      };

      var url = "${BaseProvider.baseUrl}$endpoint";
      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

      var jsonRequest = jsonEncode(requestData);
      var response = await http.post(uri, headers: headers, body: jsonRequest);
      
      if (kDebugMode) {
        print('Create review response status: ${response.statusCode}');
        print('Create review response body: ${response.body}');
      }

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        throw Exception("Failed to create review: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in createReview: $e');
      }
      rethrow;
    }
  }
}