class SaleReturnItemModel {
  final int id;
  final int quantity;
  final bool status;
  final String itemName;
  final int saleRecordId;
  final String customerName;

  SaleReturnItemModel({
    required this.id,
    required this.quantity,
    required this.status,
    required this.itemName,
    required this.saleRecordId,
    required this.customerName,
  });
}
