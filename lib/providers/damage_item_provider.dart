import 'package:flutter/material.dart';
import '../models/damage_item_model.dart';
import '../network/damage_item_service.dart';

class DamageItemProvider with ChangeNotifier {
  List<DamageItemModel> _damageItems = [];
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<DamageItemModel> get damageItems => _damageItems;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _isAuthenticated;

  loadDamageItems(int shopId) async {
    var result = await DamageItemService.getDamageItems(shopId);

    if (result is List<DamageItemModel>) {
      _errorMessage = null;
      _damageItems = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postDamageItem(Map<String, dynamic> data) async {
    var result = await DamageItemService.postDamageItem(data);

    if (result is DamageItemModel) {
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

  deleteDamageItem(int id) async {
    var result = await DamageItemService.deleteDamageItem(id);

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