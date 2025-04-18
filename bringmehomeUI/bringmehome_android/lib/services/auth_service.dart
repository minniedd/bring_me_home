import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _baseUrl = 'http://10.0.2.2:5115/api/Auth';

// login
  static Future<bool> login(String username, String password) async {
    final client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    try {
      final request = await client
          .postUrl(Uri.parse('http://10.0.2.2:5115/api/Auth/login'));

      request.headers.set('Content-Type', 'application/json');
      request.write(jsonEncode({
        'username': username,
        'password': password,
      }));

      final response =
          await request.close().timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final data = jsonDecode(body);
        await storeTokens(data['accessToken'], data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('⚠️ Login error: $e');
      return false;
    } finally {
      client.close();
    }
  }
  // register
  static Future<bool> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    return response.statusCode == 200;
  }
  // storing tokens
  static Future<void> storeTokens(
      String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }
  // getting access tokens
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }
  // checking if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }
  // log out
  static Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
