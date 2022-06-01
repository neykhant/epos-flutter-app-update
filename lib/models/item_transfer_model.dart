import '../models/item_model.dart';
import '../models/shop_model.dart';

class ItemTransferModel {
  final int id;
  final ShopModel shop;
  final ItemModel item;
  final int quantity;
  final String createdAt;

  ItemTransferModel({
    required this.id,
    required this.shop,
    required this.item,
    required this.quantity,
    required this.createdAt,
  });
}
