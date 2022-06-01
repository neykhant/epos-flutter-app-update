class DamageItemModel {
  final int id;
  final int quantity;
  final bool status;
  final String itemName;
  final int buyRecordId;
  final String merchantName;

  DamageItemModel({
    required this.id,
    required this.quantity,
    required this.status,
    required this.itemName,
    required this.buyRecordId,
    required this.merchantName,
  });
}
