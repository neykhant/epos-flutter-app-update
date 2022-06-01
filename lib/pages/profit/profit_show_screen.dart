import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/profit_model.dart';
import '../../providers/profit_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class ProfitShowScreen extends StatefulWidget {
  const ProfitShowScreen({Key? key}) : super(key: key);

  @override
  _ProfitShowScreenState createState() => _ProfitShowScreenState();
}

class _ProfitShowScreenState extends State<ProfitShowScreen> {
  String? startDate;
  String? endDate;
  bool _isLoading = false;

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final ProfitProvider profitProvider =
        Provider.of<ProfitProvider>(context, listen: false);
    await profitProvider.loadProfit(shopProvider.shop!.id);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      loadData();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    AppLocalizations localizations = AppLocalizations.of(context)!;

    List<Widget> widgetItems = [
      MyButton(
        fontSize: 14.0, //16
        verticalPadding: 12.0, //15
        horizontalPadding: 18.0, //20
        label: startDate ?? localizations.start_date,
        onPressed: () async {
          DateTime? _startDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime.now(),
          );
          setState(() {
            startDate = _startDate.toString().substring(0, 10);
          });
        },
        primary: Theme.of(context).primaryColor,
      ),
      const SizedBox(width: 10.0),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          '~',
          style: kTextStyle(size: 27.0),
        ),
      ),
      const SizedBox(width: 10.0),
      MyButton(
        fontSize: 14.0, //16
        verticalPadding: 12.0, //15
        horizontalPadding: 18.0, //20
        label: endDate ?? localizations.end_date,
        onPressed: () async {
          DateTime? _endDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime.now(),
          );
          setState(() {
            endDate = _endDate.toString().substring(0, 10);
          });
        },
        primary: Theme.of(context).primaryColor,
      ),
    ];

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.profit,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      drawer: const MyDrawer(),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ProgressHUD(
          inAsyncCall: _isLoading,
          child: Padding(
            padding: kPadding,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widgetItems,
                ),
                const SizedBox(height: 20.0),
                MyButton(
                  fontSize: 14.0, //16
                  verticalPadding: 12.0, //15
                  horizontalPadding: 18.0, //20
                  label: localizations.check,
                  onPressed: () async {
                    await context.read<ProfitProvider>().loadProfitByDate(
                        shopProvider.shop!.id, startDate ?? '', endDate ?? '');
                  },
                  primary: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 10.0),
                Consumer<ProfitProvider>(
                  builder: (BuildContext context, state, index) {
                    ProfitModel? profit = state.profit;

                    if (profit == null) {
                      return Container();
                    }

                    return Card(
                      elevation: 3.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, //8
                          vertical: 10.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localizations.total_purchase_price,
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '=',
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '${profit.purchaseTotal} Ks',
                                  style: kTextStyle(size: 16.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localizations.total_selling_price,
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '=',
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '${profit.saleRecordTotal} Ks',
                                  style: kTextStyle(size: 16.0),
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       localizations.extra_charges,
                            //       style: kTextStyle(size: 16.0),
                            //     ),
                            //     const SizedBox(
                            //       width: 20.0,
                            //     ),
                            //     Text(
                            //       '=',
                            //       style: kTextStyle(size: 16.0),
                            //     ),
                            //     const SizedBox(
                            //       width: 20.0,
                            //     ),
                            //     Text(
                            //       '${profit.extraCharges} Ks',
                            //       style: kTextStyle(size: 16.0),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localizations.total,
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '=',
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '${profit.wholeTotal} Ks',
                                  style: kTextStyle(size: 16.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localizations.expenses,
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '=',
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '${profit.expenseAmount} Ks',
                                  style: kTextStyle(size: 16.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localizations.gross_profit,
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '=',
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '${profit.wholeTotal - profit.purchaseTotal} Ks',
                                  style: kTextStyle(size: 16.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localizations.profit,
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '=',
                                  style: kTextStyle(size: 16.0),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  '${(profit.wholeTotal - profit.purchaseTotal) - profit.expenseAmount} Ks',
                                  style: kTextStyle(size: 16.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
