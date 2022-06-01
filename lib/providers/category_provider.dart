import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../network/category_service.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  CategoryModel? _category;
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<CategoryModel> get categories => _categories;
  CategoryModel? get category => _category;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  loadCategories() async {
    var result = await CategoryService.getCategories();

    if (result is List<CategoryModel>) {
      _errorMessage = null;
      _categories = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  showCategory(int id) async {
    var result = await CategoryService.getCategory(id);

    if (result is CategoryModel) {
      _errorMessage = null;
      _category = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postCategory(Map<String, dynamic> data) async {
    var result = await CategoryService.postCategory(data);

    if (result is CategoryModel) {
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

  updateCategory(int id, Map<String, dynamic> data) async {
    var result = await CategoryService.updateCategory(id, data);

    if (result is CategoryModel) {
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
