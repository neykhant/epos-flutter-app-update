import 'package:flutter/material.dart';
import '../models/monthly_model.dart';
import '../network/monthly_service.dart';

class MonthlyProvider with ChangeNotifier {
  List<MonthlyModel> _monthlies = [];
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<MonthlyModel> get monthlies => _monthlies;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _isAuthenticated;

  loadMonthly(int shopId) async {
    var result = await MonthlyService.getMonthly(shopId);

    if (result is List<MonthlyModel>) {
      _errorMessage = null;
      _monthlies = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }
}
