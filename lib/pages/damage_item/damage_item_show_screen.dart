import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../models/damage_item_model.dart';
import '../../providers/damage_item_provider.dart';
import '../../providers/shop_provider.dart';
import '../../components/elements/my_confirm_dialog.dart';
import '../../components/elements/progress_hud.dart';
import '../../utility_methods.dart';
import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';

class DamageItemShowScreen extends StatefulWidget {
  const DamageItemShowScreen({Key? key}) : super(key: key);

  @override
  _DamageItemShowScreenState createState() => _DamageItemShowScreenState();
}

class _DamageItemShowScreenState extends State<DamageItemShowScreen> {
  bool _isLoading = false;
  DamageItemModel? damageItemObject;
  List<DamageItemModel> _damageItemList = [];
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

    final DamageItemProvider damageItemProvider =
        Provider.of<DamageItemProvider>(context, listen: false);
    await damageItemProvider.loadDamageItems(shopProvider.shop!.id);

    _damageItemList = damageItemProvider.damageItems;

    buyIds.clear();
    for (var i = 0; i < _damageItemList.length; i++) {
      buyIds.add(_damageItemList[i].buyRecordId.toString());
    }

    merchantNames.clear();
    for (var i = 0; i < _damageItemList.length; i++) {
      merchantNames.add(_damageItemList[i].merchantName);
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
    List<DamageItemModel> _usedDamageItemList = _damageItemList;

    if (damageItemObject != null && merchantName == '') {
      _usedDamageItemList = _damageItemList
          .where((e) => e.buyRecordId == damageItemObject!.buyRecordId)
          .toList();
    }
    if (damageItemObject == null && merchantName != '') {
      _usedDamageItemList =
          _damageItemList.where((e) => e.merchantName == merchantName).toList();
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.damage_items,
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
                  items: buyIds.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _damageItemList.length; i++) {
                        if (_damageItemList[i].buyRecordId == int.parse(data)) {
                          setState(() {
                            damageItemObject = _damageItemList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        damageItemObject = null;
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
                      for (var i = 0; i < _damageItemList.length; i++) {
                        if (_damageItemList[i].merchantName == data) {
                          setState(() {
                            merchantName = _damageItemList[i].merchantName;
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
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedDamageItemList.length,
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
                                '${_usedDamageItemList[index].buyRecordId}',
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
                                    _usedDamageItemList[index].merchantName,
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
                                    _usedDamageItemList[index].itemName,
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
                                    '${_usedDamageItemList[index].quantity} (s)',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                              Consumer<DamageItemProvider>(
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
                                              .read<DamageItemProvider>()
                                              .deleteDamageItem(
                                                  _usedDamageItemList[index]
                                                      .id);
                                          if (state.errorMessage == null) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const DamageItemShowScreen(),
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
