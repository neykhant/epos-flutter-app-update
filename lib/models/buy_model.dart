import '../models/credit_model.dart';
import '../models/single_buy_model.dart';

class BuyModel {
  final int id;
  final String merchantName;
  final int wholeTotal;
  final int paid;
  final int credit;
  final List<SingleBuyModel> singleBuys;
  final List<CreditModel> credits;
  final String createdAt;

  BuyModel({
    required this.id,
    required this.merchantName,
    required this.wholeTotal,
    required this.paid,
    required this.credit,
    required this.singleBuys,
    required this.credits,
    required this.createdAt,
  });
}
