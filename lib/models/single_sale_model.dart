import '../models/stock_model.dart';

class SingleSaleModel {
  final int? id;
  final StockModel stock;
  final int itemPrice;
  final int quantity;
  final int totalPrice;

  SingleSaleModel({
    this.id,
    required this.stock,
    required this.itemPrice,
    required this.quantity,
    required this.totalPrice,
  });
}
