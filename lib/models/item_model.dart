import '../models/category_model.dart';

class ItemModel {
  final int id;
  final String code;
  final String itemName;
  final int buyPrice;
  final int salePrice;
  final CategoryModel? categoryModel;

  ItemModel({
    required this.id,
    required this.code,
    required this.itemName,
    required this.buyPrice,
    required this.salePrice,
    this.categoryModel,
  });
}
