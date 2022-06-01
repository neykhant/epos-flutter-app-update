import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/more_sale_model.dart';
import '../../providers/item_provider.dart';
import '../../providers/sale_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class MoreSaleItemShowScreen extends StatefulWidget {
  const MoreSaleItemShowScreen({Key? key}) : super(key: key);

  @override
  _MoreSaleItemShowScreenState createState() => _MoreSaleItemShowScreenState();
}

class _MoreSaleItemShowScreenState extends State<MoreSaleItemShowScreen> {
  bool _isLoading = false;
  MoreSaleModel? moreSaleItemObject;
  List<MoreSaleModel> _moreSaleItemList = [];
  List<String> itemNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final SaleProvider saleProvider =
        Provider.of<SaleProvider>(context, listen: false);
    await saleProvider.loadMoreSaleItems(shopProvider.shop!.id);

    _moreSaleItemList = saleProvider.moreSaleItems;

    itemNames.clear();
    for (var i = 0; i < _moreSaleItemList.length; i++) {
      itemNames.add(_moreSaleItemList[i].stock.itemModel.itemName);
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
    List<MoreSaleModel> _usedMoreSaleItemList = moreSaleItemObject == null
        ? _moreSaleItemList
        : _moreSaleItemList
            .where((e) =>
                e.stock.itemModel.itemName ==
                moreSaleItemObject!.stock.itemModel.itemName)
            .toList();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.more_sale_items,
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
                  hint: localizations.select_item,
                  mode: Mode.MENU,
                  items: itemNames.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _moreSaleItemList.length; i++) {
                        if (_moreSaleItemList[i].stock.itemModel.itemName ==
                            data) {
                          setState(() {
                            moreSaleItemObject = _moreSaleItemList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        moreSaleItemObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Consumer<ItemProvider>(
                    builder: (BuildContext context, state, index) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _usedMoreSaleItemList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            title: Text(
                              _usedMoreSaleItemList[index]
                                  .stock
                                  .itemModel
                                  .itemName,
                              style: kTextStyle(size: 16.0),
                            ),
                            trailing: Text(
                              '${_usedMoreSaleItemList[index].total} (s)',
                              style: kTextStyle(size: 16.0),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 20.0),
                MyButton(
                  verticalPadding: 12.0, //15
                  horizontalPadding: 18.0, //20
                  fontSize: 14.0, //16
                  label: localizations.create_new_item,
                  primary: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_new_item');
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
