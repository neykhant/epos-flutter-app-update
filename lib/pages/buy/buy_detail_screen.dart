import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../datetime_util.dart';
import '../../print/print_screen.dart';
import '../../print/big_print_screen.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../pages/buy/buy_show_screen.dart';
import '../../providers/buy_provider.dart';
import '../../pages/damage_item/damage_item_form_screen.dart';
import '../../models/buy_model.dart';
import '../../models/single_buy_model.dart';
import '../../components/modules/my_app_bar.dart';
import '../../utility_methods.dart';
import '../../components/elements/my_confirm_dialog.dart';

class BuyDetailScreen extends StatelessWidget {
  final BuyModel buyModel;
  const BuyDetailScreen({
    Key? key,
    required this.buyModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: convertDateToLocal(buyModel.createdAt),
        fontSize: 18.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15.0),
          Expanded(
            child: ListView.builder(
              itemCount: buyModel.singleBuys.length,
              itemBuilder: (context, index) {
                SingleBuyModel singleBuy = buyModel.singleBuys[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DamageItemFormScreen(singleBuyId: singleBuy.id),
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
                                  singleBuy.item.itemName,
                                  style: kTextStyle(size: 16.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${singleBuy.itemPrice} Ks',
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
                                '${singleBuy.quantity} (s)',
                                style: kTextStyle(size: 16.0),
                              ),
                              Text(
                                '${singleBuy.totalPrice} Ks',
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
                    localizations.merchant_name,
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    '=',
                    style: kTextStyle(),
                  ),
                  const SizedBox(width: 7.0),
                  Text(
                    buyModel.merchantName,
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
                    '${buyModel.wholeTotal} Ks',
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
                    '${buyModel.paid} Ks',
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
                      '${buyModel.credit} Ks',
                      style: kTextStyle(),
                    ),
                  ],
                ),
              ),
              Consumer<BuyProvider>(
                builder: (BuildContext context, state, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                  .read<BuyProvider>()
                                  .deleteBuy(buyModel.id);
                              if (state.errorMessage == null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BuyShowScreen(),
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
                                singles: buyModel.singleBuys,
                                name: buyModel.merchantName,
                                total: buyModel.wholeTotal.toString(),
                                extraCharges: "0",
                                discount: 0,
                                finalTotal: 0.0,
                                paid: buyModel.paid.toString(),
                                credit: buyModel.credit.toString(),
                                createdAt: buyModel.createdAt,
                                invoiceNumber: buyModel.id.toString(),
                                isBuy: true,
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
                                singles: buyModel.singleBuys,
                                name: buyModel.merchantName,
                                total: buyModel.wholeTotal.toString(),
                                extraCharges: "0",
                                discount: 0,
                                finalTotal: 0.0,
                                paid: buyModel.paid.toString(),
                                credit: buyModel.credit.toString(),
                                createdAt: buyModel.createdAt,
                                invoiceNumber: buyModel.id.toString(),
                                isBuy: true,
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
