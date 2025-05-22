import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _baseUrl = 'http://10.0.2.2:5115/api/Auth';

  // login
  static Future<bool> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(
              const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storeTokens(data['accessToken'], data['refreshToken']);
        if (kDebugMode) print('AuthService: Login successful.');
        return true;
      } else {
        if (kDebugMode) {
          print(
              'AuthService: Login failed with status: ${response.statusCode}, body: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) print('AuthService: Login error: $e');
      return false;
    }
  }

  // register
  static Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(userData),
          )
          .timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        print(
            'AuthService: Register status: ${response.statusCode}, body: ${response.body}');
      }
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print('AuthService: Register error: $e');
      return false;
    }
  }

  // store tokens
  static Future<void> storeTokens(
      String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    if (kDebugMode) print('AuthService: Tokens stored successfully.');
  }

  // get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    if (token == null) {
      return false;
    }
    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      if (kDebugMode) print('AuthService: Error checking token expiration: $e');
      return false;
    }
  }

  // logout
  static Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    if (kDebugMode) print('AuthService: User logged out and tokens cleared.');
  }

  // get user id from token
  static int? getUserIdFromToken(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      const String nameIdentifierClaimType =
          "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier";

      String? userIdString = decodedToken[nameIdentifierClaimType];

      if (userIdString != null) {
        return int.tryParse(userIdString);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
