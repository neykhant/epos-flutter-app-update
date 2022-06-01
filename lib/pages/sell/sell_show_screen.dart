import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../datetime_util.dart';
import '../../pages/sell/sell_detail_screen.dart';
import '../../models/sale_model.dart';
import '../../providers/sale_provider.dart';
import '../../providers/shop_provider.dart';

import '../../components/elements/progress_hud.dart';

import '../../utility_methods.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';

class SellShowScreen extends StatefulWidget {
  const SellShowScreen({Key? key}) : super(key: key);

  @override
  _SellShowScreenState createState() => _SellShowScreenState();
}

class _SellShowScreenState extends State<SellShowScreen> {
  bool _isLoading = false;
  SaleModel? saleObject;
  List<SaleModel> _saleList = [];
  List<String> saleIds = [];
  List<String> customerNames = [];
  String customerName = '';

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final SaleProvider saleProvider =
        Provider.of<SaleProvider>(context, listen: false);
    await saleProvider.loadSales(shopProvider.shop!.id);

    _saleList = saleProvider.sales;

    saleIds.clear();
    for (var i = 0; i < _saleList.length; i++) {
      saleIds.add(_saleList[i].id.toString());
    }

    customerNames.clear();
    for (var i = 0; i < _saleList.length; i++) {
      customerNames.add(_saleList[i].customerName);
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
    List<SaleModel> _usedSaleList = _saleList;

    if (saleObject != null && customerName == '') {
      _usedSaleList = _saleList.where((e) => e.id == saleObject!.id).toList();
    }
    if (saleObject == null && customerName != '') {
      _usedSaleList =
          _saleList.where((e) => e.customerName == customerName).toList();
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.sells,
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
                  items: saleIds,
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _saleList.length; i++) {
                        if (_saleList[i].id == int.parse(data)) {
                          setState(() {
                            saleObject = _saleList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        saleObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                DropdownSearch<String>(
                  // ignore: deprecated_member_use
                  hint: localizations.select_customer,
                  mode: Mode.MENU,
                  items: customerNames.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _saleList.length; i++) {
                        if (_saleList[i].customerName == data) {
                          setState(() {
                            customerName = _saleList[i].customerName;
                          });
                        }
                      }
                    } else {
                      setState(() {
                        customerName = '';
                      });
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedSaleList.length,
                    itemBuilder: (context, index) {
                      double discountAmount =
                          ((_usedSaleList[index].discount / 100) *
                              _usedSaleList[index].saleRecordTotal);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellDetailScreen(
                                  saleModel: _usedSaleList[index]),
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
                                  '${_usedSaleList[index].id}',
                                  style: kTextStyle(size: 16.0),
                                ),
                                Text(
                                  convertDateToLocal(
                                      _usedSaleList[index].createdAt),
                                  style: kTextStyle(size: 16.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.customer_name,
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
                                      _usedSaleList[index].customerName,
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
                                      '${_usedSaleList[index].saleRecordTotal} Ks',
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
                                //       '${_usedSaleList[index].extraCharges} Ks',
                                //       style: kTextStyle(size: 16.0),
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.discount,
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
                                      '${_usedSaleList[index].discount} %',
                                      style: kTextStyle(size: 16.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.discount_amount,
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
                                      '${discountAmount.toStringAsFixed(2)} Ks',
                                      style: kTextStyle(size: 16.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.final_total,
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
                                      '${_usedSaleList[index].finalTotal} Ks',
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
                                      '${_usedSaleList[index].paid} Ks',
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
                                      '${_usedSaleList[index].credit} Ks',
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
