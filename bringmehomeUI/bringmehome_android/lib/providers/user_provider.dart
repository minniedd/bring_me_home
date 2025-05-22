import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning_app/models/user.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends BaseProvider<User> {
  User? _currentUser;
  static const String _userStorageKey = 'current_user';

  User? get currentUser => _currentUser;

  UserProvider() : super("api/User");

  @override
  User fromJson(data) {
    if (data is! Map<String, dynamic>) {
      throw Exception("Invalid data format for User");
    }
    return User.fromJson(data);
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

  Future<User?> getUserProfile() async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        return null;
      }

      final userId = AuthService.getUserIdFromToken(token);
      if (userId == null) {
        return null;
      }

      var url = "${BaseProvider.baseUrl}$endpoint/$userId";
      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 401 || response.statusCode == 403) {
        AuthService.logout();
        throw Exception("Authentication failed. Please log in again.");
      }

      if (response.statusCode != 200) {
        String errorMessage = "Failed to get user profile";
        try {
          var data = jsonDecode(response.body);
          errorMessage = data['message'] ?? errorMessage;
        } catch (_) {}
        throw Exception(errorMessage);
      }

      var data = jsonDecode(response.body);

      if (data == null || data is! Map<String, dynamic>) {
        throw Exception("Unexpected API response format: Expected a JSON object for user profile.");
      }

      _currentUser = fromJson(data);
      await _saveUserToStorage(_currentUser!);
      notifyListeners();
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> loadCurrentUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      if (!await AuthService.isLoggedIn()) {
        _currentUser = null;
        notifyListeners();
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userStorageKey);

      if (userJson != null) {
        try {
          final userData = jsonDecode(userJson) as Map<String, dynamic>;
          _currentUser = User.fromJson(userData);
          notifyListeners();
          return _currentUser;
        } catch (e) {
          await _clearStoredUser();
        }
      }

      return await getUserProfile();
    } catch (e) {
      _currentUser = null;
      notifyListeners();
      return null;
    }
  }

  Future<void> clearUserData() async {
    _currentUser = null;
    await _clearStoredUser();
    notifyListeners();
  }

  Future<void> _saveUserToStorage(User user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> userMap = user.toJson();
      String userJson = jsonEncode(userMap);
      await prefs.setString(_userStorageKey, userJson);
    } catch (e) {}
  }

  Future<void> _clearStoredUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userStorageKey);
    } catch (e) {}
  }

  Future<User> updateProfile(Map<String, dynamic> userData) async {
    try {
      if (_currentUser?.id == null) {
        throw Exception("No logged in user");
      }

      var url = "${BaseProvider.baseUrl}$endpoint/${_currentUser!.id}";
      var uri = Uri.parse(url);
      var headers = await _createAuthHeaders();

      var jsonRequest = jsonEncode(userData);
      var response = await http.put(uri, headers: headers, body: jsonRequest);

      if (response.statusCode != 200) {
        String errorMessage = "Failed to update profile";
        try {
          var data = jsonDecode(response.body);
          errorMessage = data['message'] ?? errorMessage;
        } catch (_) {}
        throw Exception(errorMessage);
      }

      var data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) {
        throw Exception("Unexpected API response format: Expected a JSON object for updated user.");
      }
      _currentUser = fromJson(data);
      await _saveUserToStorage(_currentUser!);
      notifyListeners();
      return _currentUser!;
    } catch (e) {
      rethrow;
    }
  }
}