import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../network/item_service.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel> _items = [];
  ItemModel? _item;
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<ItemModel> get items => _items;
  ItemModel? get item => _item;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  loadItems() async {
    var result = await ItemService.getItems();

    if (result is List<ItemModel>) {
      _errorMessage = null;
      _items = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  showItem(int id) async {
    var result = await ItemService.getItem(id);

    if (result is ItemModel) {
      _errorMessage = null;
      _item = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postItem(Map<String, dynamic> data) async {
    var result = await ItemService.postItem(data);

    if (result is ItemModel) {
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

  updateItem(int id, Map<String, dynamic> data) async {
    var result = await ItemService.updateItem(id, data);

    if (result is ItemModel) {
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
