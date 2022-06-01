import 'package:flutter/material.dart';
import '../models/buy_model.dart';
import '../network/buy_service.dart';

class BuyProvider with ChangeNotifier {
  List<BuyModel> _buys = [];
  BuyModel? _buy;
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<BuyModel> get buys => _buys;
  BuyModel? get buy => _buy;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  loadBuys(int shopId) async {
    var result = await BuyService.getBuys(shopId);

    if (result is List<BuyModel>) {
      _errorMessage = null;
      _buys = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postBuy(Map<String, dynamic> data) async {
    var result = await BuyService.postBuy(data);

    if (result is BuyModel) {
      _errorMessage = null;
      _isAuthenticated = true;
      _buy = result;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result == 401) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    } else if (result >= 400) {
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  deleteBuy(int id) async {
    var result = await BuyService.deleteBuy(id);

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
