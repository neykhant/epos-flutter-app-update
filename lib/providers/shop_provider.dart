import 'package:flutter/material.dart';
import '../models/shop_model.dart';
import '../network/shop_service.dart';

class ShopProvider with ChangeNotifier {
  List<ShopModel> _shops = [];
  ShopModel? _shop;
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<ShopModel> get shops => _shops;
  ShopModel? get shop => _shop;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  ShopProvider() {
    loadShops();
  }

  loadShops() async {
    var result = await ShopService.getShops();

    if (result is List<ShopModel>) {
      _errorMessage = null;
      _shops = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  showShop(int id) async {
    var result = await ShopService.getShop(id);

    if (result is ShopModel) {
      _errorMessage = null;
      _shop = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  updateShop(int id, Map<String, dynamic> data) async {
    var result = await ShopService.updateShop(id, data);

    if (result is ShopModel) {
      _errorMessage = null;
      _isAuthenticated = true;
      _shop = result;
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
