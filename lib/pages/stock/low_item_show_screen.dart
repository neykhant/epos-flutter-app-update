import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/stock_model.dart';
import '../../pages/stock/stock_detail_screen.dart';
import '../../providers/item_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/stock_provider.dart';
import '../../utility_methods.dart';

class LowStockShowScreen extends StatefulWidget {
  const LowStockShowScreen({Key? key}) : super(key: key);

  @override
  _LowStockShowScreenState createState() => _LowStockShowScreenState();
}

class _LowStockShowScreenState extends State<LowStockShowScreen> {
  bool _isLoading = false;
  StockModel? stockObject;
  List<StockModel> _lowStockList = [];
  List<String> itemNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final StockProvider stockProvider =
        Provider.of<StockProvider>(context, listen: false);
    await stockProvider.loadLowStocks(10, shopProvider.shop!.id);

    _lowStockList = stockProvider.lowStocks;

    itemNames.clear();
    for (var i = 0; i < _lowStockList.length; i++) {
      itemNames.add(_lowStockList[i].itemModel.itemName);
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
    List<StockModel> _usedStockList = stockObject == null
        ? _lowStockList
        : _lowStockList
            .where(
                (e) => e.itemModel.itemName == stockObject!.itemModel.itemName)
            .toList();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.low_items,
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
                      for (var i = 0; i < _lowStockList.length; i++) {
                        if (_lowStockList[i].itemModel.itemName == data) {
                          setState(() {
                            stockObject = _lowStockList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        stockObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Consumer<ItemProvider>(
                    builder: (BuildContext context, state, index) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _usedStockList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            title: Text(
                              _usedStockList[index].itemModel.itemName,
                              style: kTextStyle(size: 16.0),
                            ),
                            subtitle: Text(
                              '${_usedStockList[index].quantity} (s)',
                              style: kTextStyle(size: 16.0),
                            ),
                            trailing: Text(
                              '${_usedStockList[index].itemModel.salePrice} Ks',
                              style: kTextStyle(size: 16.0),
                            ),
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });

                              await context
                                  .read<StockProvider>()
                                  .showStock(_usedStockList[index].id);

                              if (state.errorMessage != null) {
                                showAlertDialog(
                                    context: context,
                                    message: state.errorMessage ?? '');
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const StockDetailScreen(),
                                  ),
                                );
                              }

                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 20.0),
                MyButton(
                  fontSize: 14.0, //16
                  verticalPadding: 12.0, //15
                  horizontalPadding: 18.0, //20
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
