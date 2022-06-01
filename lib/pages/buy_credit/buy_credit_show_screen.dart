import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../datetime_util.dart';
import '../../pages/buy_credit/buy_credit_detail_screen.dart';
import '../../models/buy_model.dart';
import '../../providers/buy_provider.dart';
import '../../providers/shop_provider.dart';

import '../../components/elements/progress_hud.dart';

import '../../utility_methods.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';

class BuyCreditShowScreen extends StatefulWidget {
  const BuyCreditShowScreen({Key? key}) : super(key: key);

  @override
  _BuyCreditShowScreenState createState() => _BuyCreditShowScreenState();
}

class _BuyCreditShowScreenState extends State<BuyCreditShowScreen> {
  bool _isLoading = false;
  BuyModel? buyObject;
  List<BuyModel> _buyList = [];
  List<String> buyIds = [];
  List<String> merchantNames = [];
  String merchantName = '';

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final BuyProvider buyProvider =
        Provider.of<BuyProvider>(context, listen: false);
    await buyProvider.loadBuys(shopProvider.shop!.id);

    _buyList = buyProvider.buys;

    for (var i = 0; i < _buyList.length; i++) {
      buyIds.add(_buyList[i].id.toString());
    }
    for (var i = 0; i < _buyList.length; i++) {
      merchantNames.add(_buyList[i].merchantName);
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
    List<BuyModel> _usedBuyList = _buyList;

    if (buyObject != null && merchantName == '') {
      _usedBuyList = _buyList.where((e) => e.id == buyObject!.id).toList();
    }
    if (buyObject == null && merchantName != '') {
      _usedBuyList =
          _buyList.where((e) => e.merchantName == merchantName).toList();
    }

    int totalBuyCredit = 0;

    for (BuyModel buy in _usedBuyList) {
      totalBuyCredit += buy.credit;
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.buy_credits,
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
                  hint: localizations.select_invoice_id,
                  mode: Mode.MENU,
                  items: buyIds,
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _buyList.length; i++) {
                        if (_buyList[i].id == int.parse(data)) {
                          setState(() {
                            buyObject = _buyList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        buyObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                DropdownSearch<String>(
                  // ignore: deprecated_member_use
                  hint: localizations.select_merchants,
                  mode: Mode.MENU,
                  items: merchantNames.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _buyList.length; i++) {
                        if (_buyList[i].merchantName == data) {
                          setState(() {
                            merchantName = _buyList[i].merchantName;
                          });
                        }
                      }
                    } else {
                      setState(() {
                        merchantName = '';
                      });
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                Text(
                  localizations.credit_total,
                  style: kTextStyle(size: 18.0),
                ),
                Text(
                  '$totalBuyCredit Ks',
                  style: kTextStyle(size: 18.0),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedBuyList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuyCreditDetailScreen(
                                buyModel: _usedBuyList[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
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
                                  '${_usedBuyList[index].id}',
                                  style: kTextStyle(size: 16.0),
                                ),
                                Text(
                                  convertDateToLocal(
                                      _usedBuyList[index].createdAt),
                                  style: kTextStyle(size: 16.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.merchant_name,
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
                                      _usedBuyList[index].merchantName,
                                      style: kTextStyle(size: 16.0),
                                    ),
                                  ],
                                ),
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
                                      '${_usedBuyList[index].wholeTotal} Ks',
                                      style: kTextStyle(size: 16.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.paid_price,
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
                                      '${_usedBuyList[index].paid} Ks',
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
                                      '${_usedBuyList[index].credit} Ks',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
