import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:learning_app/models/adoption_application.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class AdoptionApplicationProvider extends BaseProvider<AdoptionApplication> {
  final Dio _dio;
  static const String _applicationEndpoint = '/AdoptionApplication';

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
      onError: (DioException e, handler) {
        if (kDebugMode) {
          print(
              'DIO Interceptor Error: ${e.response?.statusCode} - ${e.requestOptions.method} ${e.requestOptions.path}');
          print('Response data: ${e.response?.data}');
        }
        if (e.response?.statusCode == 401) {
          if (kDebugMode) print('Authentication error (401).');
        }
        handler.next(e);
      },
    ));
  }

  @override
  AdoptionApplication fromJson(data) {
    if (data is Map<String, dynamic>) {
      return AdoptionApplication.fromJson(data);
    }
    if (kDebugMode)
      print(
          "AdoptionApplicationProvider: fromJson received invalid data type: ${data.runtimeType}");
    throw Exception("Invalid data format for AdoptionApplication: $data");
  }

  Future<void> createApplication({
    required int userId,
    required int animalId,
    required String livingSituation,
    required bool isAnimalAllowed,
    int? reasonId,
    String? notes,
  }) async {
    if (kDebugMode)
      print(
          "AdoptionApplicationProvider: createApplication called with data...");
    try {
      final requestData = {
        'userID': userId,
        'animalID': animalId,
        'livingSituation': livingSituation,
        'isAnimalAllowed': isAnimalAllowed.toString(),
        'reasonId': reasonId,
        'notes': notes,
      };

      final url = "${BaseProvider.baseUrl}$endpoint";

      if (kDebugMode)
        print("AdoptionApplicationProvider: Submitting to URL: $url");
      if (kDebugMode)
        print("AdoptionApplicationProvider: Request data: $requestData");

      final response = await _dio.post(
        url,
        data: requestData,
      );

      if (kDebugMode)
        print(
            "AdoptionApplicationProvider: Response status: ${response.statusCode}");
      if (kDebugMode)
        print("AdoptionApplicationProvider: Response data: ${response.data}");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (kDebugMode)
          print(
              "AdoptionApplicationProvider: Application creation successful.");
      } else {
        String errorMessage =
            response.statusMessage ?? "Failed to submit application";
        if (response.data is Map<String, dynamic> &&
            response.data.containsKey('message')) {
          errorMessage = response.data['message'] as String;
        } else if (response.data is String) {
          errorMessage = response.data;
        }
        throw Exception(
            "Failed to submit application: ${response.statusCode ?? 'N/A'} - $errorMessage");
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
            '⚠️ AdoptionApplicationProvider DioException during createApplication: ${e.message}');
        print('Response status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      String userMessage =
          "An error occurred while submitting the application.";
      if (e.response?.data is Map<String, dynamic>) {
        final errors = e.response?.data['errors'];
        if (errors is Map<String, dynamic>) {
          List<String> errorMessages = [];
          errors.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.map((item) => item.toString()));
            } else {
              errorMessages.add(value.toString());
            }
          });
          if (errorMessages.isNotEmpty) {
            userMessage = "Validation errors: ${errorMessages.join(", ")}";
          } else if (e.response?.data.containsKey('title')) {
            userMessage = e.response?.data['title'];
          }
        } else if (e.response?.data.containsKey('title')) {
          userMessage = e.response?.data['title'];
        } else if (e.response?.data.containsKey('message')) {
          userMessage = e.response?.data['message'];
        }
      } else if (e.message != null) {
        userMessage = e.message!;
      }

      throw Exception(userMessage);
    } catch (e) {
      if (kDebugMode)
        print(
            "⚠️ AdoptionApplicationProvider unknown error during createApplication: ${e.toString()}");
      throw Exception("Unknown error submitting application: ${e.toString()}");
    }
  }

  @override
  Future<AdoptionApplication> insert(dynamic request) async {
    if (kDebugMode)
      print(
          "AdoptionApplicationProvider: Base insert method called (using Dio). Request: $request");
    try {
      final url = "${BaseProvider.baseUrl}$_applicationEndpoint";
      final response = await _dio.post(url, data: request);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return fromJson(response.data);
      } else {
        String errorMessage = "Failed to insert via base method";
        if (response.data is Map<String, dynamic> &&
            response.data.containsKey('message')) {
          errorMessage = response.data['message'] as String;
        } else if (response.data is String) {
          errorMessage = response.data;
        } else {
          errorMessage = response.statusMessage ?? "Unknown error";
        }
        throw Exception(
            "Failed to insert: ${response.statusCode ?? 'N/A'} - $errorMessage");
      }
    } on DioException catch (e) {
      if (kDebugMode)
        print(
            '⚠️ AdoptionApplicationProvider DioException during base insert: ${e.message}');
      throw Exception(
          "Failed to insert: ${e.response?.statusCode ?? 'N/A'} - ${e.message}");
    } catch (e) {
      if (kDebugMode)
        print(
            "⚠️ AdoptionApplicationProvider unknown error during base insert: ${e.toString()}");
      throw Exception("Unknown error during insert: ${e.toString()}");
    }
  }
}
