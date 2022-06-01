import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/all_stock_model.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/stock_provider.dart';
import '../../utility_methods.dart';

class AllStockShowScreen extends StatefulWidget {
  const AllStockShowScreen({Key? key}) : super(key: key);

  @override
  _AllStockShowScreenState createState() => _AllStockShowScreenState();
}

class _AllStockShowScreenState extends State<AllStockShowScreen> {
  bool _isLoading = false;
  AllStockModel? stockObject;
  List<AllStockModel> _allStockList = [];
  List<String> itemNames = [];

  CategoryModel? categoryObject;
  List<CategoryModel> _categoryList = [];
  List<String> categoryNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final StockProvider stockProvider =
        Provider.of<StockProvider>(context, listen: false);
    await stockProvider.loadAllStocks();

    _allStockList = stockProvider.allStocks;

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
    List<AllStockModel> _usedStockList = _allStockList;

    if (stockObject != null && categoryObject == null) {
      _usedStockList = _allStockList
          .where((e) => e.itemModel.itemName == stockObject!.itemModel.itemName)
          .toList();
    }

    if (stockObject == null && categoryObject != null) {
      _usedStockList = _allStockList
          .where((e) => e.itemModel.categoryModel!.name == categoryObject!.name)
          .toList();
    }

    if (stockObject != null && categoryObject != null) {
      _usedStockList = _allStockList
          .where((e) =>
              e.itemModel.categoryModel!.name == categoryObject!.name &&
              e.itemModel.itemName == stockObject!.itemModel.itemName)
          .toList();
    }

    if (categoryObject != null) {
      itemNames.clear();
      for (var i = 0; i < _allStockList.length; i++) {
        if (_allStockList[i].itemModel.categoryModel!.id ==
            categoryObject!.id) {
          itemNames.add(_allStockList[i].itemModel.itemName);
        }
      }
    } else {
      itemNames.clear();
      for (var i = 0; i < _allStockList.length; i++) {
        itemNames.add(_allStockList[i].itemModel.itemName);
      }
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.all_stocks,
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
                      for (var i = 0; i < _allStockList.length; i++) {
                        if (_allStockList[i].itemModel.itemName == data) {
                          setState(() {
                            stockObject = _allStockList[i];
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
                Consumer<StockProvider>(
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
                              '${_usedStockList[index].itemModel.categoryModel?.name}',
                              style: kTextStyle(size: 16.0),
                            ),
                            trailing: Text(
                              '${_usedStockList[index].quantity} (s)',
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
