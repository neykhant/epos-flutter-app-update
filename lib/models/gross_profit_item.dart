import '../../models/stock_model.dart';

class GrossProfitItemModel {
  final StockModel stock;
  final int quantity;
  final int subtotal;

  GrossProfitItemModel({
    required this.stock,
    required this.quantity,
    required this.subtotal,
  });
}
