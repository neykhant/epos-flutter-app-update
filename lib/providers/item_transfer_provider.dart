import 'package:flutter/material.dart';
import '../models/item_transfer_model.dart';
import '../network/item_transfer_service.dart';

class ItemTransferProvider with ChangeNotifier {
  List<ItemTransferModel> _itemTransfers = [];
  ItemTransferModel? _itemTransfer;
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<ItemTransferModel> get itemTransfers => _itemTransfers;

  ItemTransferModel? get itemTransfer => _itemTransfer;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _isAuthenticated;

  loadItemTransfers(int shopId) async {
    var result = await ItemTransferService.getItemTransfers(shopId);

    if (result is List<ItemTransferModel>) {
      _errorMessage = null;
      _itemTransfers = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  showItemTransfer(int id) async {
    var result = await ItemTransferService.getItemTransfer(id);

    if (result is ItemTransferModel) {
      _errorMessage = null;
      _itemTransfer = result;
      _isAuthenticated = true;
    } else if (result >= 500) {
      _errorMessage = 'Our Service is wrong!';
    } else if (result >= 400) {
      _isAuthenticated = false;
      _errorMessage = 'Your request is bad!';
    }
    notifyListeners();
  }

  postItemTransfer(Map<String, dynamic> data) async {
    var result = await ItemTransferService.postItemTransfer(data);

    if (result is ItemTransferModel) {
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

  deleteItemTransfer(int id) async {
    var result = await ItemTransferService.deleteItemTransfer(id);

    if (result == 204) {
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
