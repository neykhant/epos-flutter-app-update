import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/monthly_model.dart';
import '../../providers/monthly_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class MonthlyShowScreen extends StatefulWidget {
  const MonthlyShowScreen({Key? key}) : super(key: key);

  @override
  _MonthlyShowScreenState createState() => _MonthlyShowScreenState();
}

class _MonthlyShowScreenState extends State<MonthlyShowScreen> {
  bool _isLoading = false;
  List<MonthlyModel> _monthlyList = [];
  List<String> years = [];
  MonthlyModel? monthObject;

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final MonthlyProvider monthlyProvider =
        Provider.of<MonthlyProvider>(context, listen: false);
    await monthlyProvider.loadMonthly(shopProvider.shop!.id);

    _monthlyList = monthlyProvider.monthlies;

    years.clear();
    for (var i = 0; i < _monthlyList.length; i++) {
      years.add(_monthlyList[i].year);
    }

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

    List<MonthlyModel> _usedMonthlyList = monthObject == null
        ? _monthlyList
        : _monthlyList.where((e) => e.year == monthObject!.year).toList();

    for (MonthlyModel monthly in _usedMonthlyList) {
      purchaseTotal += monthly.purchaseTotal;
      saleRecordTotal += monthly.saleRecordTotal;
      // extraCharges += monthly.extraCharges;
      wholeTotal += monthly.wholeTotal;
      credit += monthly.credit;
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.monthly,
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
                DropdownSearch<String>(
                  // ignore: deprecated_member_use
                  hint: localizations.select_year,
                  mode: Mode.MENU,
                  items: years.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _monthlyList.length; i++) {
                        if (_monthlyList[i].year == data) {
                          setState(() {
                            monthObject = _monthlyList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        monthObject = null;
                      });
                    }
                  },
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
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedMonthlyList.length,
                    itemBuilder: (context, index) {
                      MonthlyModel yearly = _usedMonthlyList[index];

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
                                '${yearly.year}-${yearly.month}',
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
                                    '${yearly.purchaseTotal} Ks',
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
                                    '${yearly.saleRecordTotal} Ks',
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
                              //       '${yearly.extraCharges} Ks',
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
                                    '${yearly.wholeTotal} Ks',
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
                                    '${yearly.credit} Ks',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
