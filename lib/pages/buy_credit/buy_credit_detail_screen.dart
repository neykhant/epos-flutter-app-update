import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../datetime_util.dart';
import '../../pages/buy_credit/buy_credit_show_screen.dart';
import '../../pages/buy_credit/buy_credit_form_screen.dart';
import '../../models/buy_model.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_confirm_dialog.dart';
import '../../print/print_screen.dart';
import '../../providers/credit_provider.dart';
import '../../components/elements/my_button.dart';
import '../../models/credit_model.dart';
import '../../components/modules/my_app_bar.dart';
import '../../utility_methods.dart';

class BuyCreditDetailScreen extends StatelessWidget {
  final BuyModel buyModel;
  const BuyCreditDetailScreen({
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
          Consumer<CreditProvider>(
            builder: (BuildContext context, state, index) {
              return Expanded(
                child: ListView.builder(
                  itemCount: buyModel.credits.length,
                  itemBuilder: (context, index) {
                    CreditModel credit = buyModel.credits[index];

                    return Card(
                      elevation: 3.0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        title: Text(
                          '${credit.amount} Ks',
                          style: kTextStyle(size: 16.0),
                        ),
                        subtitle: Text(
                          convertDateToLocal(credit.createdAt),
                          style: kTextStyle(size: 16.0),
                        ),
                        trailing: IconButton(
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
                                    .read<CreditProvider>()
                                    .deleteBuyCredit(credit.id);
                                if (state.errorMessage == null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BuyCreditShowScreen(),
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
                      ),
                    );
                  },
                ),
              );
            },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyButton(
                    verticalPadding: 15.0,
                    horizontalPadding: 20.0,
                    fontSize: 16.0,
                    label: localizations.create_credit,
                    primary: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BuyCreditFormScreen(buyRecordId: buyModel.id),
                        ),
                      );
                    },
                  ),
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
                            credits: buyModel.credits,
                            isBuy: true,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
