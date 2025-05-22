import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:learning_app/models/animal.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class FavouritesProvider extends BaseProvider<Animal> {
  FavouritesProvider() : super("api/UserFavoriteAnimal");

  @override
  Animal fromJson(data) => Animal.fromJson(data);

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

  Future<bool> toggleFavorite(int animalId, bool isFavorite) async {
    try {
      var url = "${BaseProvider.baseUrl}$endpoint/$animalId/favorite";
      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

      var jsonRequest = jsonEncode({'isFavorite': isFavorite});
      var response = await http.put(uri, headers: headers, body: jsonRequest);

      if (kDebugMode) {
        print('Toggle favorite response status: ${response.statusCode}');
        print('Toggle favorite response body: ${response.body}');
      }

      return response.statusCode == 200 || 
             (response.statusCode == 404 && !isFavorite);
    } catch (e) {
      if (kDebugMode) {
        print('Error in toggleFavorite: $e');
      }
      return false;
    }
  }

  Future<List<Animal>> getFavorites() async {
    try {
      var url = "${BaseProvider.baseUrl}$endpoint/favorites";
      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

      var response = await http.get(uri, headers: headers);

      if (kDebugMode) {
        print('Get favorites response status: ${response.statusCode}');
        print('Get favorites response body: ${response.body}');
      }

      if (response.statusCode != 200) return [];

      var data = jsonDecode(response.body);
      if (data is! List) return [];

      return data.map((animalJson) => Animal.fromJson(animalJson)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting favorites: $e');
      }
      return [];
    }
  }
}