import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../../print/item_transfer_print/print_screen_item_transfer.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/my_confirm_dialog.dart';
import '../../components/elements/progress_hud.dart';
import '../../datetime_util.dart';
import '../../models/item_transfer_model.dart';
import '../../providers/item_transfer_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class ItemTransferShowScreen extends StatefulWidget {
  const ItemTransferShowScreen({Key? key}) : super(key: key);

  @override
  _ItemTransferShowScreenState createState() => _ItemTransferShowScreenState();
}

class _ItemTransferShowScreenState extends State<ItemTransferShowScreen> {
  bool _isLoading = false;
  ItemTransferModel? itemTransferObject;
  List<ItemTransferModel> _itemTransferList = [];
  List<String> toShopNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final ItemTransferProvider itemTransferProvider =
        Provider.of<ItemTransferProvider>(context, listen: false);
    await itemTransferProvider.loadItemTransfers(shopProvider.shop!.id);

    _itemTransferList = itemTransferProvider.itemTransfers;

    toShopNames.clear();
    for (var i = 0; i < _itemTransferList.length; i++) {
      toShopNames.add(_itemTransferList[i].shop.shopName);
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
    List<ItemTransferModel> _usedItemTransferList = itemTransferObject == null
        ? _itemTransferList
        : _itemTransferList
            .where((e) => e.shop.shopName == itemTransferObject!.shop.shopName)
            .toList();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.item_transfers,
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
                  hint: localizations.select_shop,
                  mode: Mode.MENU,
                  items: toShopNames.toSet().toList(),
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _itemTransferList.length; i++) {
                        if (_itemTransferList[i].shop.shopName == data) {
                          setState(() {
                            itemTransferObject = _itemTransferList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        itemTransferObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedItemTransferList.length,
                    itemBuilder: (context, index) {
                      ItemTransferModel itemTransfer =
                          _usedItemTransferList[index];

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
                                convertDateToLocal(itemTransfer.createdAt),
                                style: kTextStyle(size: 16.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localizations.shop_name,
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
                                    itemTransfer.shop.shopName,
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
                                    itemTransfer.item.itemName,
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
                                    '${itemTransfer.quantity} (s)',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                              Consumer<ItemTransferProvider>(
                                builder: (BuildContext context, state, index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      IconButton(
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
                                                  .read<ItemTransferProvider>()
                                                  .deleteItemTransfer(
                                                      itemTransfer.id);
                                              if (state.errorMessage == null) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ItemTransferShowScreen(),
                                                  ),
                                                );
                                              } else {
                                                showAlertDialog(
                                                    context: context,
                                                    message:
                                                        state.errorMessage ??
                                                            '');
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.print,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () async {
                                          await context
                                              .read<ItemTransferProvider>()
                                              .showItemTransfer(
                                                  itemTransfer.id);
                                          if (state.errorMessage == null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PrintScreenItemTransfer(
                                                        itemTransfer:
                                                            state.itemTransfer),
                                              ),
                                            );
                                          } else {
                                            showAlertDialog(
                                                context: context,
                                                message:
                                                    state.errorMessage ?? '');
                                          }
                                        },
                                      ),
                                    ],
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
                const SizedBox(height: 20.0),
                MyButton(
                  fontSize: 14.0, //16
                  verticalPadding: 12.0, //15
                  horizontalPadding: 18.0, //20
                  label: localizations.create_item_transfer,
                  primary: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_new_item_transfer');
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
