import 'package:flutter/material.dart';

import '../models/all_stock_model.dart';
import '../models/stock_model.dart';
import '../network/stock_service.dart';

class StockProvider with ChangeNotifier {
  List<StockModel> _stocks = [];
  List<AllStockModel> _allStocks = [];
  List<StockModel> _lowStocks = [];
  StockModel? _stock;
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<StockModel> get stocks => _stocks;
  List<AllStockModel> get allStocks => _allStocks;
  List<StockModel> get lowStocks => _lowStocks;
  StockModel? get stock => _stock;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  loadStocks(int shopId) async {
    var result = await StockService.getStocks(shopId);
    if (result is List<StockModel>) {
      // print(stocks);
      _errorMessage = null;
      _stocks = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  loadLowStocks(int quantity, int shopId) async {
    var result = await StockService.getLowStocks(quantity, shopId);

    if (result is List<StockModel>) {
      _errorMessage = null;
      _lowStocks = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  loadAllStocks() async {
    var result = await StockService.getAllStocks();

    if (result is List<AllStockModel>) {
      _errorMessage = null;
      _allStocks = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  showStock(int id) async {
    var result = await StockService.getStock(id);

    if (result is StockModel) {
      _errorMessage = null;
      _stock = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postStock(Map<String, dynamic> data) async {
    var result = await StockService.postStock(data);

    if (result is StockModel) {
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

  updateStock(int id, Map<String, dynamic> data) async {
    var result = await StockService.updateStock(id, data);

    if (result is StockModel) {
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
