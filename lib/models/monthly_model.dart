class MonthlyModel {
  final String month;
  final String year;
  final int purchaseTotal;
  final int saleRecordTotal;
  final int extraCharges;
  final int wholeTotal;
  final int credit;

  MonthlyModel({
    required this.month,
    required this.year,
    required this.purchaseTotal,
    required this.saleRecordTotal,
    required this.extraCharges,
    required this.wholeTotal,
    required this.credit,
  });
}
