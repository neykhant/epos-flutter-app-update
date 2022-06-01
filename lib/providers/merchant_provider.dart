import 'package:flutter/material.dart';
import '../network/merchant_service.dart';
import '../models/merchant_model.dart';

class MerchantProvider with ChangeNotifier {
  List<MerchantModel> _merchants = [];
  MerchantModel? _merchant;
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<MerchantModel> get merchants => _merchants;
  MerchantModel? get merchant => _merchant;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  loadMerchants(int shopId) async {
    var result = await MerchantService.getMerchants(shopId);

    if (result is List<MerchantModel>) {
      _errorMessage = null;
      _merchants = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  showMerchant(int id) async {
    var result = await MerchantService.getMerchant(id);

    if (result is MerchantModel) {
      _errorMessage = null;
      _merchant = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postMerchant(Map<String, dynamic> data) async {
    var result = await MerchantService.postMerchant(data);

    if (result is MerchantModel) {
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

  updateMerchant(int id, Map<String, dynamic> data) async {
    var result = await MerchantService.updateMerchant(id, data);

    if (result is MerchantModel) {
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
}
