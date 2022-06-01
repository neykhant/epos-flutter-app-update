import 'package:flutter/material.dart';
import '../network/yearly_service.dart';
import '../models/yearly_model.dart';

class YearlyProvider with ChangeNotifier {
  List<YearlyModel> _yearlies = [];
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<YearlyModel> get yearlies => _yearlies;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _isAuthenticated;

  loadYearly(int shopId) async {
    var result = await YearlyService.getYearly(shopId);

    if (result is List<YearlyModel>) {
      _errorMessage = null;
      _yearlies = result;
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
