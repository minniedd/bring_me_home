import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:learning_app/models/adoption_application.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class AdoptionApplicationProvider extends BaseProvider<AdoptionApplication> {
  AdoptionApplicationProvider() : super("api/AdoptionApplication");

  @override
  AdoptionApplication fromJson(data) {
    return AdoptionApplication.fromJson(data);
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

  Future<List<AdoptionApplication>> getApplications() async {
    try {
      var url = "${BaseProvider.baseUrl}$endpoint";
      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

      var response = await http.get(uri, headers: headers);

      if (kDebugMode) {
        print('Get applications response status: ${response.statusCode}');
        print('Get applications response body: ${response.body}');
      }

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        
        List<dynamic> items;
        if (data is Map<String, dynamic> && data.containsKey('items')) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        } else {
          throw Exception("Unexpected response format");
        }

        return items.map((item) => fromJson(item)).toList();
      } else {
        throw Exception("Failed to load applications: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getApplications: $e');
      }
      rethrow;
    }
  }

  Future<List<AdoptionApplication>> getHistory() async {
    try {
      var url = "${BaseProvider.baseUrl}$endpoint/history";
      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

      var response = await http.get(uri, headers: headers);

      if (kDebugMode) {
        print('Get history response status: ${response.statusCode}');
        print('Get history response body: ${response.body}');
      }

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        
        List<dynamic> items;
        if (data is Map<String, dynamic> && data.containsKey('items')) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        } else {
          throw Exception("Unexpected response format");
        }

        return items.map((item) => fromJson(item)).toList();
      } else {
        throw Exception("Failed to load history: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getHistory: $e');
      }
      rethrow;
    }
  }

  Future<AdoptionApplication> createApplication({
    required int userId,
    required int animalId,
    required String livingSituation,
    required String isAnimalAllowed,
    int? reasonId,
    String? notes,
  }) async {
    try {
      final requestData = {
        'userID': userId,
        'animalID': animalId,
        'livingSituation': livingSituation,
        'isAnimalAllowed': isAnimalAllowed,
        'reasonId': reasonId,
        'notes': notes,
      };

      var url = "${BaseProvider.baseUrl}$endpoint";
      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

      var jsonRequest = jsonEncode(requestData);
      var response = await http.post(uri, headers: headers, body: jsonRequest);

      if (kDebugMode) {
        print('Create application response status: ${response.statusCode}');
        print('Create application response body: ${response.body}');
      }

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        throw Exception("Failed to create application: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in createApplication: $e');
      }
      rethrow;
    }
  }
}