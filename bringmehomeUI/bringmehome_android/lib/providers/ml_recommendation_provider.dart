import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:learning_app/models/animal.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class MlRecommendationProvider extends BaseProvider<Animal> {
  MlRecommendationProvider() : super("api/MlRecommendations");

  @override
  Animal fromJson(data) {
    return Animal.fromJson(data);
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

  Future<List<Animal>> getRecommendations(int userId, {int count = 5}) async {
    try {
      var url = "${BaseProvider.baseUrl}$endpoint/user/$userId?count=$count";
      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

      var response = await http.get(uri, headers: headers);

      if (kDebugMode) {
        print('Get recommendations response status: ${response.statusCode}');
        print('Get recommendations response body: ${response.body}');
      }

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        
        List<dynamic> items;
        if (data is List) {
          items = data;
        } else {
          throw Exception("Unexpected response format");
        }

        return items.map((item) => fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Failed to load recommendations: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getRecommendationsForUser: $e');
      }
      rethrow;
    }
  }
}