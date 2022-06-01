import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/category_model.dart';
import '../../models/item_model.dart';
import '../../pages/item/item_detail_screen.dart';
import '../../providers/category_provider.dart';
import '../../providers/item_provider.dart';
import '../../utility_methods.dart';

class ItemShowScreen extends StatefulWidget {
  const ItemShowScreen({Key? key}) : super(key: key);

  @override
  _ItemShowScreenState createState() => _ItemShowScreenState();
}

class _ItemShowScreenState extends State<ItemShowScreen> {
  bool _isLoading = false;
  ItemModel? itemObject;
  List<ItemModel> _itemList = [];
  List<String> itemNames = [];

  CategoryModel? categoryObject;
  List<CategoryModel> _categoryList = [];
  List<String> categoryNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ItemProvider itemProvider =
        Provider.of<ItemProvider>(context, listen: false);
    await itemProvider.loadItems();

    _itemList = itemProvider.items;

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
    List<ItemModel> _usedItemList = _itemList;

    if (itemObject != null && categoryObject == null) {
      _usedItemList =
          _itemList.where((e) => e.itemName == itemObject!.itemName).toList();
    }
    if (itemObject == null && categoryObject != null) {
      _usedItemList = _itemList
          .where((e) => e.categoryModel?.name == categoryObject!.name)
          .toList();
    }
    if (itemObject != null && categoryObject != null) {
      _usedItemList = _itemList
          .where((e) =>
              e.categoryModel?.name == categoryObject!.name &&
              e.itemName == itemObject!.itemName)
          .toList();
    }

    if (categoryObject != null) {
      itemNames.clear();
      for (var i = 0; i < _itemList.length; i++) {
        if (_itemList[i].categoryModel!.id == categoryObject!.id) {
          itemNames.add(_itemList[i].itemName);
        }
      }
    } else {
      itemNames.clear();
      for (var i = 0; i < _itemList.length; i++) {
        itemNames.add(_itemList[i].itemName);
      }
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.item_show,
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
                  items: itemNames.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _itemList.length; i++) {
                        if (_itemList[i].itemName == data) {
                          setState(() {
                            itemObject = _itemList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        itemObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Consumer<ItemProvider>(
                    builder: (BuildContext context, state, index) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _usedItemList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            title: Text(
                              _usedItemList[index].itemName,
                              style: kTextStyle(size: 16.0),
                            ),
                            subtitle: Text(
                              _usedItemList[index].categoryModel?.name ?? '',
                              style: kTextStyle(size: 16.0),
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  '${_usedItemList[index].buyPrice} Ks',
                                  style: kTextStyle(size: 16.0),
                                ),
                                Text(
                                  '${_usedItemList[index].salePrice} Ks',
                                  style: kTextStyle(size: 16.0),
                                ),
                              ],
                            ),
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });

                              await context
                                  .read<ItemProvider>()
                                  .showItem(_usedItemList[index].id);

                              if (state.errorMessage != null) {
                                showAlertDialog(
                                    context: context,
                                    message: state.errorMessage ?? '');
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ItemDetailScreen(),
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
                  verticalPadding: 12.0, //15
                  horizontalPadding: 20.0,
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
