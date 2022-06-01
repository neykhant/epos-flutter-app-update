import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/category_model.dart';
import '../../models/gross_profit_item.dart';
import '../../providers/category_provider.dart';
import '../../providers/profit_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/stock_provider.dart';
import '../../utility_methods.dart';

class GrossProfitItemShowScreen extends StatefulWidget {
  const GrossProfitItemShowScreen({Key? key}) : super(key: key);

  @override
  _GrossProfitItemShowScreenState createState() =>
      _GrossProfitItemShowScreenState();
}

class _GrossProfitItemShowScreenState extends State<GrossProfitItemShowScreen> {
  bool _isLoading = false;
  GrossProfitItemModel? grossProfitObject;
  List<GrossProfitItemModel> _grossProfitList = [];
  List<String> itemNames = [];

  CategoryModel? categoryObject;
  List<CategoryModel> _categoryList = [];
  List<String> categoryNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final ProfitProvider profitProvider =
        Provider.of<ProfitProvider>(context, listen: false);
    await profitProvider.loadGrossProfitItem(shopProvider.shop!.id);

    _grossProfitList = profitProvider.grossProfitItems;

    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.loadCategories();

    _categoryList = categoryProvider.categories;

    categoryNames.clear();
    for (var i = 0; i < _categoryList.length; i++) {
      categoryNames.add(_categoryList[i].name);
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
    List<GrossProfitItemModel> _usedGrossProfitItemList = _grossProfitList;

    if (grossProfitObject != null && categoryObject == null) {
      _usedGrossProfitItemList = _grossProfitList
          .where((e) =>
              e.stock.itemModel.itemName ==
              grossProfitObject!.stock.itemModel.itemName)
          .toList();
    }

    if (grossProfitObject == null && categoryObject != null) {
      _usedGrossProfitItemList = _grossProfitList
          .where((e) =>
              e.stock.itemModel.categoryModel!.name == categoryObject!.name)
          .toList();
    }

    if (grossProfitObject != null && categoryObject != null) {
      _usedGrossProfitItemList = _grossProfitList
          .where((e) =>
              e.stock.itemModel.categoryModel!.name == categoryObject!.name &&
              e.stock.itemModel.itemName ==
                  grossProfitObject!.stock.itemModel.itemName)
          .toList();
    }

    if (categoryObject != null) {
      itemNames.clear();
      for (var i = 0; i < _grossProfitList.length; i++) {
        if (_grossProfitList[i].stock.itemModel.categoryModel!.id ==
            categoryObject!.id) {
          itemNames.add(_grossProfitList[i].stock.itemModel.itemName);
        }
      }
    } else {
      itemNames.clear();
      for (var i = 0; i < _grossProfitList.length; i++) {
        itemNames.add(_grossProfitList[i].stock.itemModel.itemName);
      }
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.item_gross_profit,
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
                  hint: localizations.select_category,
                  mode: Mode.MENU,
                  items: categoryNames.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _categoryList.length; i++) {
                        if (_categoryList[i].name == data) {
                          setState(() {
                            categoryObject = _categoryList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        categoryObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                DropdownSearch<String>(
                  // ignore: deprecated_member_use
                  hint: localizations.select_item,
                  mode: Mode.MENU,
                  items: itemNames,
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _grossProfitList.length; i++) {
                        if (_grossProfitList[i].stock.itemModel.itemName ==
                            data) {
                          setState(() {
                            grossProfitObject = _grossProfitList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        grossProfitObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Consumer<StockProvider>(
                    builder: (BuildContext context, state, index) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _usedGrossProfitItemList.length,
                      itemBuilder: (context, index) {
                        GrossProfitItemModel grossProfitItem =
                            _usedGrossProfitItemList[index];

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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.item_code,
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
                                      grossProfitItem.stock.itemModel.code,
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
                                      grossProfitItem.stock.itemModel.itemName,
                                      style: kTextStyle(size: 16.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.item_category,
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
                                      '${grossProfitItem.stock.itemModel.categoryModel?.name}',
                                      style: kTextStyle(size: 16.0),
                                    ),
                                  ],
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
                                      '${grossProfitItem.quantity * grossProfitItem.stock.itemModel.buyPrice}',
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
                                      '${grossProfitItem.subtotal}',
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
                                      '${grossProfitItem.subtotal - (grossProfitItem.quantity * grossProfitItem.stock.itemModel.buyPrice)}',
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
                }),
                const SizedBox(height: 20.0),
                MyButton(
                  fontSize: 14.0, //16
                  verticalPadding: 12.0, //15
                  horizontalPadding: 18.0, //20
                  label: localizations.create_stock,
                  primary: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_new_stock');
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
