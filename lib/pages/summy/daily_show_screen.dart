import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/daily_model.dart';
import '../../providers/daily_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class DailyShowScreen extends StatefulWidget {
  const DailyShowScreen({Key? key}) : super(key: key);

  @override
  _DailyShowScreenState createState() => _DailyShowScreenState();
}

class _DailyShowScreenState extends State<DailyShowScreen> {
  String? startDate;
  String? endDate;
  bool _isLoading = false;
  List<DailyModel> _dailyList = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final DailyProvider dailyProvider =
        Provider.of<DailyProvider>(context, listen: false);
    await dailyProvider.loadDaily(shopProvider.shop!.id);

    _dailyList = dailyProvider.dailies;

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
    int purchaseTotal = 0;
    int saleRecordTotal = 0;
    // int extraCharges = 0;
    int wholeTotal = 0;
    int credit = 0;

    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    AppLocalizations localizations = AppLocalizations.of(context)!;

    final DailyProvider dailyProvider = Provider.of<DailyProvider>(context);

    for (DailyModel daily in dailyProvider.dailies) {
      purchaseTotal += daily.purchaseTotal;
      saleRecordTotal += daily.saleRecordTotal;
      // extraCharges += daily.extraCharges;
      wholeTotal += daily.wholeTotal;
      credit += daily.credit;
    }

    List<Widget> widgetItems = [
      MyButton(
        fontSize: 14.0, //16
        verticalPadding: 12.0, //15
        horizontalPadding: 18.0, //20
        label: startDate ?? localizations.start_date,
        onPressed: () async {
          if (_dailyList.isNotEmpty) {
            DateTime? _startDate = await showDatePicker(
              context: context,
              initialDate: _dailyList.last.day,
              firstDate: _dailyList.last.day,
              lastDate: _dailyList.first.day,
            );
            setState(() {
              startDate = _startDate.toString().substring(0, 10);
            });
          }
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
          if (_dailyList.isNotEmpty) {
            DateTime? _endDate = await showDatePicker(
              context: context,
              initialDate: _dailyList.first.day,
              firstDate: _dailyList.last.day,
              lastDate: _dailyList.first.day,
            );
            setState(() {
              endDate = _endDate.toString().substring(0, 10);
            });
          }
        },
        primary: Theme.of(context).primaryColor,
      ),
    ];

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.daily,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0, //18
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
                    await context.read<DailyProvider>().loadDailyByDate(
                        shopProvider.shop!.id, startDate ?? '', endDate ?? '');
                  },
                  primary: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 10.0),
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
                      '$purchaseTotal Ks',
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
                      '$saleRecordTotal Ks',
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
                //       '$extraCharges Ks',
                //       style: kTextStyle(size: 16.0),
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.income_total,
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
                      '$wholeTotal Ks',
                      style: kTextStyle(size: 16.0),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.credit,
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
                      '$credit Ks',
                      style: kTextStyle(size: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Consumer<DailyProvider>(
                  builder: (BuildContext context, state, index) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.dailies.length,
                        itemBuilder: (context, index) {
                          DailyModel daily = state.dailies[index];

                          return Card(
                            elevation: 3.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 10.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(daily.day),
                                    style: kTextStyle(size: 16.0),
                                  ),
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
                                        '${daily.purchaseTotal} Ks',
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
                                        '${daily.saleRecordTotal} Ks',
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
                                  //       '${daily.extraCharges} Ks',
                                  //       style: kTextStyle(size: 16.0),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        localizations.income_total,
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
                                        '${daily.wholeTotal} Ks',
                                        style: kTextStyle(size: 16.0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        localizations.credit,
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
                                        '${daily.credit} Ks',
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
