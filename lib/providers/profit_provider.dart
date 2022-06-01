import 'package:flutter/material.dart';
import '../models/profit_model.dart';
import '../network/profit_service.dart';
import '../models/gross_profit_item.dart';
import '../models/sale_items_model.dart';

class ProfitProvider with ChangeNotifier {
  ProfitModel? _profit;
  List<GrossProfitItemModel> _grossProfitItems = [];
  List<SaleItemsModel> _saleItems = [];
  String? _errorMessage;
  bool _isAuthenticated = false;

  ProfitModel? get profit => _profit;
  List<GrossProfitItemModel> get grossProfitItems => _grossProfitItems;
  List<SaleItemsModel> get saleItems => _saleItems;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  loadProfit(int shopId) async {
    var result = await ProfitService.getProfit(shopId);

    if (result is ProfitModel) {
      _errorMessage = null;
      _profit = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  loadProfitByDate(int shopId, String startDate, String endDate) async {
    var result =
        await ProfitService.getProfitByDate(shopId, startDate, endDate);

    if (result is ProfitModel) {
      _errorMessage = null;
      _profit = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  loadGrossProfitItem(int shopId) async {
    var result = await ProfitService.getGrossProfitItem(shopId);

    if (result is List<GrossProfitItemModel>) {
      _errorMessage = null;
      _grossProfitItems = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  loadSaleItems(int shopId) async {
    var result = await ProfitService.getSaleItems(shopId);

    if (result is List<SaleItemsModel>) {
      _errorMessage = null;
      _saleItems = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  loadSaleItemsByDate(int shopId, String startDate, String endDate) async {
    var result =
        await ProfitService.getSaleItemsByDate(shopId, startDate, endDate);

    if (result is List<SaleItemsModel>) {
      _errorMessage = null;
      _saleItems = result;
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
