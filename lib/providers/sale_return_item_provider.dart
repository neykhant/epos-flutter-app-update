import 'package:flutter/material.dart';
import '../models/sale_return_item_model.dart';
import '../network/sale_return_item_service.dart';

class SaleReturnItemProvider with ChangeNotifier {
  List<SaleReturnItemModel> _saleReturnItems = [];
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<SaleReturnItemModel> get saleReturnItems => _saleReturnItems;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _isAuthenticated;

  loadSaleReturnItems(int shopId) async {
    var result = await SaleReturnItemService.getSaleReturnItems(shopId);

    if (result is List<SaleReturnItemModel>) {
      _errorMessage = null;
      _saleReturnItems = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postSaleReturnItem(Map<String, dynamic> data) async {
    var result = await SaleReturnItemService.postSaleReturnItem(data);

    if (result is SaleReturnItemModel) {
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

  deleteSaleReturnItem(int id) async {
    var result = await SaleReturnItemService.deleteSaleReturnItem(id);

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
