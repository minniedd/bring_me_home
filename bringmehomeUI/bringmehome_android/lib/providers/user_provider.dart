import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:learning_app/models/user.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends BaseProvider<User> {
  final Dio _dio;
  final String _baseUrl = "http://10.0.2.2:5115/api";
  User? _currentUser;
  static const String _userStorageKey = 'current_user';

  User? get currentUser => _currentUser;

  UserProvider()
      : _dio = Dio(),
        super("api/User") {
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
  User fromJson(data) {
    if (data is! Map<String, dynamic>) {
      throw Exception("Invalid data format for User");
    }
    return User.fromJson(data);
  }

  Future<User?> getUserProfile() async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) return null;

      final response = await _dio.get('$_baseUrl/User');

      if (response.statusCode != 200) {
        final errorMessage = response.data?['message'] ?? "Failed to get user profile";
        throw Exception(errorMessage);
      }

      if (response.data is! Map<String, dynamic> || response.data['items'] is! List) {
        throw Exception("Unexpected API response format");
      }

      final items = response.data['items'] as List;
      if (items.isEmpty) throw Exception("User data not found");

      _currentUser = fromJson(items.first);
      await _saveUserToStorage(_currentUser!);
      notifyListeners();
      return _currentUser;
    } on DioException catch (e) {
      throw Exception(e.message ?? "Failed to get user profile");
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
        } catch (_) {
          await _clearStoredUser();
        }
      }

      return await getUserProfile();
    } catch (_) {
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
    if (kDebugMode) print("UserProvider: Saving user to storage");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> userMap = user.toJson();
      String userJson = jsonEncode(userMap);
      await prefs.setString(_userStorageKey, userJson);
      if (kDebugMode) print("UserProvider: User data saved successfully.");
    } catch (e) {
      if (kDebugMode) print("UserProvider: Error saving user data: $e");
    }
  }

  Future<void> _clearStoredUser() async {
    if (kDebugMode) print("UserProvider: Clearing stored user data");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userStorageKey);
      if (kDebugMode) print("UserProvider: Stored user data cleared.");
    } catch (e) {
      if (kDebugMode) print("UserProvider: Error clearing user data: $e");
    }
  }

  Future<User> updateProfile(Map<String, dynamic> userData) async {
    try {
      if (_currentUser?.id == null) {
        throw Exception("No logged in user");
      }

      final response = await _dio.put(
        '$_baseUrl/User/${_currentUser!.id}',
        data: userData,
      );

      if (response.statusCode != 200) {
        throw Exception(response.data?['message'] ?? "Failed to update profile");
      }

      _currentUser = fromJson(response.data);
      await _saveUserToStorage(_currentUser!);
      notifyListeners();
      return _currentUser!;
    } on DioException catch (e) {
      throw Exception(e.message ?? "Failed to update profile");
    }
  }
}
