import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:learning_app/models/User.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends BaseProvider<User>{
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
       onError: (DioException e, handler) {
          if (kDebugMode) {
            print('DIO Interceptor Error: ${e.response?.statusCode} - ${e.requestOptions.method} ${e.requestOptions.path}');
            print('Response data: ${e.response?.data}');
          }
          handler.next(e);
       },
    ));
  }

  @override
  User fromJson(data) {
    if (data is Map<String, dynamic>) {
       return User.fromJson(data);
    }
     if (kDebugMode) print("UserProvider: fromJson received invalid data type: ${data.runtimeType}");
     throw Exception("Invalid data format for User: $data");
  }

  Future<User?> getUserProfile() async {
    if (kDebugMode) print("UserProvider: getUserProfile called");
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        if (kDebugMode) print("UserProvider: No access token found for getUserProfile, returning null");
        return null; 
      }

      final url = "$_baseUrl/User";
      if (kDebugMode) print("UserProvider: Fetching user profile from: $url");

      final response = await _dio.get(url);

      if (kDebugMode) print("UserProvider: getUserProfile response status: ${response.statusCode}");
      if (kDebugMode) print("UserProvider: getUserProfile raw response data: ${response.data}");


      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic> && response.data.containsKey('items')) {
          final List<dynamic> items = response.data['items'];
          if (items.isNotEmpty) {
            final userData = items.first;
            if (userData is Map<String, dynamic>) {
               if (kDebugMode) print("UserProvider: Successfully extracted user data from 'items'");
               _currentUser = User.fromJson(userData);

               await _saveUserToStorage(_currentUser!); 

               notifyListeners();
               return _currentUser;
            } else {
               if (kDebugMode) print("UserProvider: First item in 'items' is not a Map");
               throw Exception("Invalid user data format in 'items' list");
            }
          } else {
             if (kDebugMode) print("UserProvider: 'items' list is empty in response");
             throw Exception("User data 'items' list is empty");
          }
        } else {
          if (kDebugMode) print("UserProvider: API response data is not a Map with an 'items' key");
          throw Exception("Unexpected API response format for user profile");
        }
      } else {
         if (kDebugMode) print("UserProvider: API returned non-200 status: ${response.statusCode}");
        final errorMessage = response.data?['message'] ?? "Failed to get user profile";
        throw Exception("Failed to get user profile: ${response.statusCode} - $errorMessage");
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("UserProvider: Dio error getting user profile: ${e.message}");
        print("UserProvider: Response status: ${e.response?.statusCode}");
        print("UserProvider: Response data: ${e.response?.data}");
      }
      throw Exception("Failed to get user profile: ${e.message}");
    } catch (e) {
      if (kDebugMode) {
        print("UserProvider: Unknown error getting user profile: $e");
      }
      throw Exception("Failed to get user profile: ${e.toString()}");
    }
  }

  Future<User?> loadCurrentUser() async {
    if (kDebugMode) print("UserProvider: loadCurrentUser called");
    if (_currentUser != null) {
      if (kDebugMode) print("UserProvider: _currentUser already set, returning");
      return _currentUser;
    }

    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (kDebugMode) print("UserProvider: AuthService.isLoggedIn() returned $isLoggedIn");

      if (!isLoggedIn) {
        _currentUser = null;
        notifyListeners();
        if (kDebugMode) print("UserProvider: User not logged in, returning null");
        return null;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString(_userStorageKey);
      if (kDebugMode) print("UserProvider: User data from storage: ${userJson != null ? 'Found' : 'null'}");


      if (userJson != null) {
        try {
           var userData = jsonDecode(userJson);
            if (userData is Map<String, dynamic>) {
              _currentUser = User.fromJson(userData);
               if (kDebugMode) print("UserProvider: Successfully loaded user from storage");
              notifyListeners();
              return _currentUser;
            } else {
               if (kDebugMode) print("UserProvider: Invalid user data format in storage, clearing storage");
               await _clearStoredUser();
            }
        } catch(e) {
           if (kDebugMode) print("UserProvider: Error decoding or parsing stored user data: $e, clearing storage");
            await _clearStoredUser();
        }
      }

      if (kDebugMode) print("UserProvider: No valid user in storage, attempting to fetch from API");
       return await getUserProfile(); 

    } catch (e) {
      if (kDebugMode) print("UserProvider: Error during loadCurrentUser process: $e");
      _currentUser = null;
      notifyListeners();
      return null;
    }
  }

  Future<void> clearUserData() async {
    _currentUser = null;
    await _clearStoredUser();
    notifyListeners();
    if (kDebugMode) print("UserProvider: User data cleared.");
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
    if (kDebugMode) print("UserProvider: updateProfile called");
    try {
      if (_currentUser == null || _currentUser!.id == null) {
        if (kDebugMode) print("UserProvider: No logged in user or user ID missing for update");
        throw Exception("No logged in user or user ID missing for update");
      }

      final userId = _currentUser!.id!; 
      final url = "$_baseUrl/User/$userId"; 
      if (kDebugMode) print("UserProvider: Updating user profile at: $url");

      final response = await _dio.put(
        url,
        data: userData,
      );

      if (kDebugMode) print("UserProvider: updateProfile response status: ${response.statusCode}");
      if (kDebugMode) print("UserProvider: updateProfile response data: ${response.data}");


      if (response.statusCode == 200) {
         if (kDebugMode) print("UserProvider: Successfully updated profile");
        _currentUser = fromJson(response.data); 
        await _saveUserToStorage(_currentUser!);
        notifyListeners();
        return _currentUser!;
      } else {
         if (kDebugMode) print("UserProvider: Update profile failed: ${response.statusCode}");
        final errorMessage = response.data?['message'] ?? "Failed to update profile";
        throw Exception("Failed to update profile: ${response.statusCode} - $errorMessage");
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("UserProvider: Dio error updating profile: ${e.message}");
        print("UserProvider: Response status: ${e.response?.statusCode}");
        print("UserProvider: Response data: ${e.response?.data}");
      }
      throw Exception("Failed to update profile: ${e.message}");
    } catch (e) {
      if (kDebugMode) {
        print("UserProvider: Unknown error updating profile: $e");
      }
      throw Exception("Failed to update profile: ${e.toString()}");
    }
  }
}