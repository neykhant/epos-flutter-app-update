import 'package:flutter/material.dart';
import '../token.dart';
import '../models/login_model.dart';
import '../network/auth_service.dart';

class AuthProvider with ChangeNotifier {
  LoginModel? _loginModel;
  String? _errorMessage;
  bool _isAuthenticated = false;

  LoginModel? get loginModel => _loginModel;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    getUser();
  }

  login(Map<String, String> credential) async {
    var result = await AuthService.login(credential);

    if (result is LoginModel) {
      _errorMessage = null;
      _loginModel = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _isAuthenticated = false;
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Credential is wrong!';
    }
    notifyListeners();
  }

  logout() async {
    await Token.deleteToken();
    _isAuthenticated = false;
    notifyListeners();
  }

  getUser() async {
    var result = await AuthService.getUser();

    if (result is LoginModel) {
      _loginModel = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _isAuthenticated = false;
    } else if (result >= 400) {
      _isAuthenticated = false;
    }
    notifyListeners();
  }
}
