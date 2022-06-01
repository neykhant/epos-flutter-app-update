import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../network/expense_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<ExpenseModel> _expenses = [];
  ExpenseModel? _expense;
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<ExpenseModel> get expenses => _expenses;

  ExpenseModel? get expense => _expense;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _isAuthenticated;

  loadExpenses(int shopId) async {
    var result = await ExpenseService.getExpenses(shopId);

    if (result is List<ExpenseModel>) {
      _errorMessage = null;
      _expenses = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  loadExpensesByDate(int shopId, String startDate, String endDate) async {
    var result =
        await ExpenseService.getExpensesByDate(shopId, startDate, endDate);

    if (result is List<ExpenseModel>) {
      _errorMessage = null;
      _expenses = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  showExpense(int id) async {
    var result = await ExpenseService.getExpense(id);

    if (result is ExpenseModel) {
      _errorMessage = null;
      _expense = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postExpense(Map<String, dynamic> data) async {
    var result = await ExpenseService.postExpense(data);

    if (result is ExpenseModel) {
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

  updateExpense(int id, Map<String, dynamic> data) async {
    var result = await ExpenseService.updateExpense(id, data);

    if (result is ExpenseModel) {
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

  deleteExpense(int id) async {
    var result = await ExpenseService.deleteExpense(id);

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
