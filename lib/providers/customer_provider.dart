import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../network/customer_service.dart';

class CustomerProvider with ChangeNotifier {
  List<CustomerModel> _customers = [];
  CustomerModel? _customer;
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<CustomerModel> get customers => _customers;
  CustomerModel? get customer => _customer;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  loadCustomers(int shopId) async {
    var result = await CustomerService.getCustomers(shopId);

    if (result is List<CustomerModel>) {
      _errorMessage = null;
      _customers = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  showCustomer(int id) async {
    var result = await CustomerService.getCustomer(id);

    if (result is CustomerModel) {
      _errorMessage = null;
      _customer = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postCustomer(Map<String, dynamic> data) async {
    var result = await CustomerService.postCustomer(data);

    if (result is CustomerModel) {
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

  updateCustomer(int id, Map<String, dynamic> data) async {
    var result = await CustomerService.updateCustomer(id, data);

    if (result is CustomerModel) {
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
