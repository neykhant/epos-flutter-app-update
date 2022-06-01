class PurchaseModel {
  final int id;
  final String merchantName;
  final int wholeTotal;
  final int paid;
  final int credit;
  final String createdAt;

  PurchaseModel({
    required this.id,
    required this.merchantName,
    required this.wholeTotal,
    required this.paid,
    required this.credit,
    required this.createdAt,
  });
}
