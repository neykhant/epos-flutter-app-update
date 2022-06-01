import 'package:flutter/material.dart';
import '../models/daily_model.dart';
import '../network/daily_service.dart';

class DailyProvider with ChangeNotifier {
  List<DailyModel> _dailies = [];
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<DailyModel> get dailies => _dailies;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _isAuthenticated;

  loadDaily(int shopId) async {
    var result = await DailyService.getDaily(shopId);

    if (result is List<DailyModel>) {
      _errorMessage = null;
      _dailies = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  loadDailyByDate(int shopId, String startDate, String endDate) async {
    var result = await DailyService.getDailyByDate(shopId, startDate, endDate);

    if (result is List<DailyModel>) {
      _errorMessage = null;
      _dailies = result;
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
