import '../models/item_model.dart';

class SingleBuyModel {
  final int? id;
  final ItemModel item;
  final int itemPrice;
  final int quantity;
  final int totalPrice;

  SingleBuyModel({
    this.id,
    required this.item,
    required this.itemPrice,
    required this.quantity,
    required this.totalPrice,
  });
}
