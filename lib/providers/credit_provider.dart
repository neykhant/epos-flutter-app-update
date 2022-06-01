import 'package:flutter/material.dart';

import '../models/credit_model.dart';
import '../network/credit_service.dart';

class CreditProvider with ChangeNotifier {
  String? _errorMessage;
  bool _isAuthenticated = false;

  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  postCredit(Map<String, dynamic> data) async {
    // print(data);
    var result = await CreditService.postCredit(data);

    if (result is CreditModel) {
      _errorMessage = null;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result == 400) {
      _errorMessage = 'Your request is bad!';
    } else if (result > 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postBuyCredit(Map<String, dynamic> data) async {
    var result = await CreditService.postBuyCredit(data);

    if (result is CreditModel) {
      _errorMessage = null;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result == 400) {
      _errorMessage = 'Your request is bad!';
    } else if (result > 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  deleteCredit(int id) async {
    var result = await CreditService.deleteCredit(id);

    if (result == 204) {
      _errorMessage = null;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result > 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  deleteBuyCredit(int id) async {
    var result = await CreditService.deleteBuyCredit(id);

    if (result == 204) {
      _errorMessage = null;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result > 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }
}
