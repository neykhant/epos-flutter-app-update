import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../providers/shop_provider.dart';
import '../../components/elements/my_confirm_dialog.dart';
import '../../components/elements/progress_hud.dart';
import '../../utility_methods.dart';
import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../models/sale_return_item_model.dart';
import '../../providers/sale_return_item_provider.dart';

class SaleReturnItemShowScreen extends StatefulWidget {
  const SaleReturnItemShowScreen({Key? key}) : super(key: key);

  @override
  _SaleReturnItemShowScreenState createState() =>
      _SaleReturnItemShowScreenState();
}

class _SaleReturnItemShowScreenState extends State<SaleReturnItemShowScreen> {
  bool _isLoading = false;
  SaleReturnItemModel? saleReturnItemObject;
  List<SaleReturnItemModel> _saleReturnItemList = [];
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

    final SaleReturnItemProvider saleReturnItemProvider =
        Provider.of<SaleReturnItemProvider>(context, listen: false);
    await saleReturnItemProvider.loadSaleReturnItems(shopProvider.shop!.id);

    _saleReturnItemList = saleReturnItemProvider.saleReturnItems;

    saleIds.clear();
    for (var i = 0; i < _saleReturnItemList.length; i++) {
      saleIds.add(_saleReturnItemList[i].saleRecordId.toString());
    }

    customerNames.clear();
    for (var i = 0; i < _saleReturnItemList.length; i++) {
      customerNames.add(_saleReturnItemList[i].customerName);
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
    List<SaleReturnItemModel> _usedSaleReturnItemList = _saleReturnItemList;

    if (saleReturnItemObject != null && customerName == '') {
      _usedSaleReturnItemList = _saleReturnItemList
          .where((e) => e.saleRecordId == saleReturnItemObject!.saleRecordId)
          .toList();
    }
    if (saleReturnItemObject == null && customerName != '') {
      _usedSaleReturnItemList = _saleReturnItemList
          .where((e) => e.customerName == customerName)
          .toList();
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.sale_return,
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
                  items: saleIds.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _saleReturnItemList.length; i++) {
                        if (_saleReturnItemList[i].saleRecordId ==
                            int.parse(data)) {
                          setState(() {
                            saleReturnItemObject = _saleReturnItemList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        saleReturnItemObject = null;
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
                      for (var i = 0; i < _saleReturnItemList.length; i++) {
                        if (_saleReturnItemList[i].customerName == data) {
                          setState(() {
                            customerName = _saleReturnItemList[i].customerName;
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
                    itemCount: _usedSaleReturnItemList.length,
                    itemBuilder: (context, index) {
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
                                '${_usedSaleReturnItemList[index].saleRecordId}',
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
                                    _usedSaleReturnItemList[index].customerName,
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localizations.item_name,
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
                                    _usedSaleReturnItemList[index].itemName,
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localizations.quantity,
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
                                    '${_usedSaleReturnItemList[index].quantity} (s)',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                              Consumer<SaleReturnItemProvider>(
                                builder: (BuildContext context, state, i) {
                                  return IconButton(
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
                                              .read<SaleReturnItemProvider>()
                                              .deleteSaleReturnItem(
                                                  _usedSaleReturnItemList[index]
                                                      .id);
                                          if (state.errorMessage == null) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const SaleReturnItemShowScreen(),
                                              ),
                                            );
                                          } else {
                                            showAlertDialog(
                                                context: context,
                                                message:
                                                    state.errorMessage ?? '');
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
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
