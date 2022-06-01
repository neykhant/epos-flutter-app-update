import 'package:flutter/material.dart';
import '../models/more_sale_model.dart';
import '../models/sale_model.dart';
import '../network/sale_service.dart';

class SaleProvider with ChangeNotifier {
  List<SaleModel> _sales = [];
  List<MoreSaleModel> _moreSaleItems = [];
  String? _errorMessage;
  bool _isAuthenticated = false;
  SaleModel? _sale;

  List<SaleModel> get sales => _sales;
  SaleModel? get sale => _sale;
  List<MoreSaleModel> get moreSaleItems => _moreSaleItems;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  loadSales(int shopId) async {
    var result = await SaleService.getSales(shopId);

    if (result is List<SaleModel>) {
      _errorMessage = null;
      _sales = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  loadMoreSaleItems(int shopId) async {
    var result = await SaleService.getMoreSaleItems(shopId);

    if (result is List<MoreSaleModel>) {
      _errorMessage = null;
      _moreSaleItems = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postSale(Map<String, dynamic> data) async {
    var result = await SaleService.postSale(data);

    if (result is SaleModel) {
      _errorMessage = null;
      _isAuthenticated = true;
      _sale = result;
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

  deleteSale(int id) async {
    var result = await SaleService.deleteSale(id);

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

  restoreSale(int id) async {
    var result = await SaleService.restoreSale(id);

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
