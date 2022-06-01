import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../datetime_util.dart';
import '../../print/print_screen.dart';
import '../../print/big_print_screen.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_confirm_dialog.dart';
import '../../pages/sell/sell_show_screen.dart';
import '../../providers/sale_provider.dart';
import '../../models/sale_model.dart';
import '../../models/single_sale_model.dart';
import '../../components/modules/my_app_bar.dart';
import '../../utility_methods.dart';
import '../sale_return_item/sale_return_item_form_screen.dart';

class SellDetailScreen extends StatelessWidget {
  final SaleModel saleModel;
  const SellDetailScreen({
    Key? key,
    required this.saleModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    double discountAmount =
        ((saleModel.discount / 100) * saleModel.saleRecordTotal);

    return Scaffold(
      appBar: MyAppBar(
        title: convertDateToLocal(saleModel.createdAt),
        fontSize: 18.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15.0),
          Expanded(
            child: ListView.builder(
              itemCount: saleModel.singleSales.length,
              itemBuilder: (context, index) {
                SingleSaleModel singleSale = saleModel.singleSales[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaleReturnItemFormScreen(
                            singleSaleId: singleSale.id),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 150.0,
                                child: Text(
                                  singleSale.stock.itemModel.itemName,
                                  style: kTextStyle(size: 16.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${singleSale.itemPrice} Ks',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                  const SizedBox(width: 7.0),
                                  Text(
                                    localizations.per_item,
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${singleSale.quantity} (s)',
                                style: kTextStyle(size: 16.0),
                              ),
                              Text(
                                '${singleSale.totalPrice} Ks',
                                style: kTextStyle(size: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.customer_name,
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '=',
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    saleModel.customerName,
                    style: kTextStyle(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.total,
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '=',
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '${saleModel.saleRecordTotal} Ks',
                    style: kTextStyle(),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       localizations.extra_charges,
              //       style: kTextStyle(),
              //     ),
              //     const SizedBox(width: 7.0),
              //     Text(
              //       '=',
              //       style: kTextStyle(),
              //     ),
              //     const SizedBox(width: 7.0),
              //     Text(
              //       '${saleModel.extraCharges} Ks',
              //       style: kTextStyle(),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.discount,
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '=',
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '${saleModel.discount} %',
                    style: kTextStyle(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.discount_amount,
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '=',
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '${discountAmount.toStringAsFixed(2)} Ks',
                    style: kTextStyle(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.final_total,
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '=',
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '${saleModel.finalTotal} Ks',
                    style: kTextStyle(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.paid_price,
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '=',
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '${saleModel.paid} Ks',
                    style: kTextStyle(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.credit,
                      style: kTextStyle(),
                    ),
                    const SizedBox(width: 7.0),
                    Text(
                      '=',
                      style: kTextStyle(),
                    ),
                    const SizedBox(width: 7.0),
                    Text(
                      '${saleModel.credit} Ks',
                      style: kTextStyle(),
                    ),
                  ],
                ),
              ),
              Consumer<SaleProvider>(
                builder: (BuildContext context, state, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.restore,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          showConfirmDialog(
                            context: context,
                            message: localizations.sure_restore,
                            onPressed: () async {
                              Navigator.pop(context);
                              await context
                                  .read<SaleProvider>()
                                  .restoreSale(saleModel.id);
                              if (state.errorMessage == null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SellShowScreen(),
                                  ),
                                );
                              } else {
                                showAlertDialog(
                                    context: context,
                                    message: state.errorMessage ?? '');
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 7.0),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showConfirmDialog(
                            context: context,
                            message: localizations.sure_delete,
                            onPressed: () async {
                              Navigator.pop(context);

                              await context
                                  .read<SaleProvider>()
                                  .deleteSale(saleModel.id);

                              if (state.errorMessage == null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SellShowScreen(),
                                  ),
                                );
                              } else {
                                showAlertDialog(
                                    context: context,
                                    message: state.errorMessage ?? '');
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 7.0),
                      IconButton(
                        icon: const Icon(
                          Icons.print,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrintScreen(
                                singles: saleModel.singleSales,
                                name: saleModel.customerName,
                                total: saleModel.saleRecordTotal.toString(),
                                extraCharges: saleModel.extraCharges.toString(),
                                discount: saleModel.discount,
                                finalTotal: saleModel.finalTotal,
                                paid: saleModel.paid.toString(),
                                credit: saleModel.credit.toString(),
                                createdAt: saleModel.createdAt,
                                invoiceNumber: saleModel.id.toString(),
                                isBuy: false,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 7.0),
                      IconButton(
                        icon: const Icon(
                          Icons.print,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BigPrintScreen(
                                singles: saleModel.singleSales,
                                name: saleModel.customerName,
                                total: saleModel.saleRecordTotal.toString(),
                                extraCharges: saleModel.extraCharges.toString(),
                                discount: saleModel.discount,
                                finalTotal: saleModel.finalTotal,
                                paid: saleModel.paid.toString(),
                                credit: saleModel.credit.toString(),
                                createdAt: saleModel.createdAt,
                                invoiceNumber: saleModel.id.toString(),
                                isBuy: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
