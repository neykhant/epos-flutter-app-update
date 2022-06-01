import '../models/item_model.dart';

class PriceTrackModel {
  final int id;
  final ItemModel itemModel;
  final int buyPrice;
  final int salePrice;
  final String createdAt;

  PriceTrackModel({
    required this.id,
    required this.itemModel,
    required this.buyPrice,
    required this.salePrice,
    required this.createdAt,
  });
}
