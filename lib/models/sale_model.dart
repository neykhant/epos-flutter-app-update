import '../models/credit_model.dart';
import '../models/single_sale_model.dart';

class SaleModel {
  final int id;
  final String customerName;
  final int purchaseTotal;
  final int saleRecordTotal;
  final int extraCharges;
  final int wholeTotal;
  final dynamic finalTotal;
  final int paid;
  final dynamic credit;
  final double discount;
  final String remark;
  final String note;
  final List<SingleSaleModel> singleSales;
  final List<CreditModel> credits;
  final String createdAt;

  SaleModel({
    required this.id,
    required this.customerName,
    required this.purchaseTotal,
    required this.saleRecordTotal,
    required this.extraCharges,
    required this.wholeTotal,
    required this.finalTotal,
    required this.paid,
    required this.credit,
    required this.discount,
    required this.remark,
    required this.note,
    required this.singleSales,
    required this.credits,
    required this.createdAt,
  });
}
