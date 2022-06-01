import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/yearly_model.dart';
import '../../providers/yearly_provider.dart';
import '../../providers/shop_provider.dart';

import '../../components/elements/progress_hud.dart';

import '../../utility_methods.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';

class YearlyShowScreen extends StatefulWidget {
  const YearlyShowScreen({Key? key}) : super(key: key);

  @override
  _YearlyShowScreenState createState() => _YearlyShowScreenState();
}

class _YearlyShowScreenState extends State<YearlyShowScreen> {
  bool _isLoading = false;
  List<YearlyModel> _yearlyList = [];
  List<String> years = [];
  YearlyModel? yearObject;

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final YearlyProvider yearlyProvider =
        Provider.of<YearlyProvider>(context, listen: false);
    await yearlyProvider.loadYearly(shopProvider.shop!.id);

    _yearlyList = yearlyProvider.yearlies;

    years.clear();
    for (var i = 0; i < _yearlyList.length; i++) {
      years.add(_yearlyList[i].year);
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
    List<YearlyModel> _usedYearlyList = yearObject == null
        ? _yearlyList
        : _yearlyList.where((e) => e.year == yearObject!.year).toList();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.yearly,
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
                      for (var i = 0; i < _yearlyList.length; i++) {
                        if (_yearlyList[i].year == data) {
                          setState(() {
                            yearObject = _yearlyList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        yearObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedYearlyList.length,
                    itemBuilder: (context, index) {
                      YearlyModel yearly = _usedYearlyList[index];

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
                                yearly.year,
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
