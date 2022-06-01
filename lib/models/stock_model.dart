import '../models/item_model.dart';

class StockModel {
  final int id;
  final int quantity;
  final ItemModel itemModel;

  StockModel({
    required this.id,
    required this.quantity,
    required this.itemModel,
  });
}
