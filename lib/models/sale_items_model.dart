import '../../models/stock_model.dart';

class SaleItemsModel {
  final DateTime day;
  final StockModel stock;
  final int quantity;
  final int subtotal;

  SaleItemsModel({
    required this.day,
    required this.stock,
    required this.quantity,
    required this.subtotal,
  });
}
