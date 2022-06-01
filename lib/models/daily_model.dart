class DailyModel {
  final DateTime day;
  final int purchaseTotal;
  final int saleRecordTotal;
  final int extraCharges;
  final int wholeTotal;
  final int credit;

  DailyModel({
    required this.day,
    required this.purchaseTotal,
    required this.saleRecordTotal,
    required this.extraCharges,
    required this.wholeTotal,
    required this.credit,
  });
}
