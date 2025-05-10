import 'dart:async';
import 'package:dio/dio.dart';
import 'package:learning_app/models/adoption_application.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';
//import 'package:http/http.dart' as http;

class AdoptionApplicationProvider extends BaseProvider<AdoptionApplication> {
  final Dio _dio;
  static const String _applicationEndpoint = '/AdoptionApplication';
  final String _baseUrl = 'http://10.0.2.2:5115/api';

  AdoptionApplicationProvider()
      : _dio = Dio(),
        super("api/AdoptionApplication") {
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthService.getAccessToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
    ));
  }

  @override
  AdoptionApplication fromJson(data) {
    if (data is! Map<String, dynamic>) {
      throw Exception("Invalid data format for AdoptionApplication");
    }
    return AdoptionApplication.fromJson(data);
  }

  Future<List<AdoptionApplication>> getHistory() async {
  try {
    final response = await _dio.get(
      '$_baseUrl/AdoptionApplication/history',
      options: Options(validateStatus: (status) => status! < 500),
    );

    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic> && response.data.containsKey('items')) {
        final List<dynamic> applicationsJson = response.data['items'];

        return applicationsJson
            .map((applicationJson) => AdoptionApplication.fromJson(applicationJson))
            .toList();
      } else {
        print('Unexpected response data structure: ${response.data}');
        return [];
      }
    } else {
      print('API returned status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching history: $e');
    return [];
  }
}

  Future<void> createApplication({
    required int userId,
    required int animalId,
    required String livingSituation,
    required String isAnimalAllowed,
    int? reasonId,
    String? notes,
  }) async {
    final requestData = {
      'userID': userId,
      'animalID': animalId,
      'livingSituation': livingSituation,
      'isAnimalAllowed': isAnimalAllowed,
      'reasonId': reasonId,
      'notes': notes,
    };

    final url = "${BaseProvider.baseUrl}$endpoint";
    final response = await _dio.post(url, data: requestData);

    if (response.statusCode == null || response.statusCode! >= 300) {
      throw _parseErrorResponse(response);
    }
  }

  @override
  Future<AdoptionApplication> insert(dynamic request) async {
    final url = "${BaseProvider.baseUrl}$_applicationEndpoint";
    final response = await _dio.post(url, data: request);

    if (response.statusCode == null || response.statusCode! >= 300) {
      throw _parseErrorResponse(response);
    }

    return fromJson(response.data);
  }

  Exception _parseErrorResponse(Response response) {
    final statusCode = response.statusCode ?? 'N/A';
    String errorMessage = response.statusMessage ?? "Request failed";

    if (response.data is Map<String, dynamic>) {
      if (response.data['message'] != null) {
        errorMessage = response.data['message'];
      } else if (response.data['title'] != null) {
        errorMessage = response.data['title'];
      } else if (response.data['errors'] != null) {
        final errors = response.data['errors'] as Map<String, dynamic>;
        errorMessage = errors.entries
            .map((e) => e.value is List ? e.value.join(', ') : e.value.toString())
            .join(', ');
      }
    } else if (response.data is String) {
      errorMessage = response.data;
    }

    return Exception("Request failed ($statusCode): $errorMessage");
  }
}
