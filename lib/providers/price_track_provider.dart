import 'package:flutter/material.dart';
import '../models/price_track_model.dart';
import '../network/price_track_service.dart';

class PriceTrackProvider with ChangeNotifier {
  List<PriceTrackModel> _priceTracks = [];
  String? _errorMessage;
  bool _isAuthenticated = false;

  List<PriceTrackModel> get priceTracks => _priceTracks;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  loadPriceTracks() async {
    var result = await PriceTrackService.getPriceTracks();

    if (result is List<PriceTrackModel>) {
      _errorMessage = null;
      _priceTracks = result;
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
