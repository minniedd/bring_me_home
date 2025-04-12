import 'dart:async';

import '../services/auth_service.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    _isLoggedIn = await AuthService.isLoggedIn();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final success = await AuthService.login(username, password)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Login request timed out');
      });

      _isLoggedIn = success;
      return success;
    } catch (e) {
      debugPrint('Login error: $e');
      _isLoggedIn = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    final success = await AuthService.register(userData).timeout(const Duration(seconds: 10),onTimeout: (){
      throw TimeoutException('Sign up request timed out');
    });

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
