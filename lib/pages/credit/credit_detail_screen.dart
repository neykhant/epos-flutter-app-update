import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../datetime_util.dart';
import '../../pages/credit/credit_show_screen.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../print/print_screen.dart';
import '../../providers/credit_provider.dart';
import '../../pages/credit/credit_form_screen.dart';
import '../../components/elements/my_button.dart';
import '../../models/credit_model.dart';
import '../../models/sale_model.dart';
import '../../components/modules/my_app_bar.dart';
import '../../components/elements/my_confirm_dialog.dart';
import '../../utility_methods.dart';

class CreditDetailScreen extends StatelessWidget {
  final SaleModel saleModel;
  const CreditDetailScreen({
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
          Consumer<CreditProvider>(
            builder: (BuildContext context, state, index) {
              return Expanded(
                child: ListView.builder(
                  itemCount: saleModel.credits.length,
                  itemBuilder: (context, index) {
                    CreditModel credit = saleModel.credits[index];

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
                                    .deleteCredit(credit.id);
                                if (state.errorMessage == null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreditShowScreen(),
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
                              CreditFormScreen(saleRecordId: saleModel.id),
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
                            credits: saleModel.credits,
                            isBuy: false,
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
