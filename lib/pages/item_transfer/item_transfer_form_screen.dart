import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/elements/my_button.dart';
import '../../../components/elements/my_form_wrapper.dart';
import '../../../components/elements/my_text_form_field.dart';
import '../../../components/elements/progress_hud.dart';
import '../../../components/modules/my_app_bar.dart';
import '../../../utility_methods.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../models/shop_model.dart';
import '../../models/stock_model.dart';
import '../../providers/item_transfer_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/stock_provider.dart';

class ItemTransferFormScreen extends StatefulWidget {
  const ItemTransferFormScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ItemTransferFormScreenState createState() => _ItemTransferFormScreenState();
}

class _ItemTransferFormScreenState extends State<ItemTransferFormScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();

  ShopModel? _toShopObject;

  StockModel? _stockObject;
  List<StockModel> _stockList = [];
  List<String> itemNames = [];

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final StockProvider stockProvider =
        Provider.of<StockProvider>(context, listen: false);
    await stockProvider.loadStocks(shopProvider.shop!.id);

    _stockList = stockProvider.stocks;

    itemNames.clear();
    for (var i = 0; i < _stockList.length; i++) {
      itemNames.add(_stockList[i].itemModel.itemName);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);
    List<String> toShopNames = [];
    for (var i = 0; i < shopProvider.shops.length; i++) {
      if (shopProvider.shop!.id != shopProvider.shops[i].id) {
        toShopNames.add(shopProvider.shops[i].shopName);
      }
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.create_item_transfer,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        child: MyFormWrapper(
          formWidth: 340.0,
          formKey: _formKey,
          height: 400.0,
          children: [
            Text(
              localizations.shop_name,
              style: kTextStyle(size: 16.0),
            ),
            DropdownSearch<String>(
              // ignore: deprecated_member_use
              hint: localizations.select_shop,
              mode: Mode.MENU,
              items: toShopNames,
              showClearButton: true,
              showSearchBox: true,
              onChanged: (String? data) {
                for (var i = 0; i < shopProvider.shops.length; i++) {
                  if (shopProvider.shops[i].shopName == data) {
                    setState(() {
                      _toShopObject = shopProvider.shops[i];
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 17.0),
            Text(
              localizations.item_name,
              style: kTextStyle(size: 16.0),
            ),
            DropdownSearch<String>(
              // ignore: deprecated_member_use
              hint: localizations.select_item,
              mode: Mode.MENU,
              items: itemNames.toSet().toList(),
              showClearButton: true,
              showSearchBox: true,
              onChanged: (String? data) {
                for (var i = 0; i < _stockList.length; i++) {
                  if (_stockList[i].itemModel.itemName == data) {
                    setState(() {
                      _stockObject = _stockList[i];
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 17.0),
            Text(
              localizations.quantity,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _quantityController,
              decoration: kInputDecoration,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_quantity;
                }
                return null;
              },
            ),
            Consumer<ItemTransferProvider>(
              builder: (BuildContext context, state, index) {
                return Center(
                  child: MyButton(
                    label: localizations.save,
                    fontSize: 14.0, //16
                    verticalPadding: 10.0, //15
                    horizontalPadding: 14.0, //20
                    primary: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        if (_toShopObject != null) {
                          if (_stockObject != null) {
                            await state.postItemTransfer({
                              'shop_id': shopProvider.shop!.id,
                              'to_shop_id': _toShopObject!.id,
                              'item_id': _stockObject!.itemModel.id,
                              'quantity': _quantityController.text,
                            });

                            if (state.errorMessage != null) {
                              showAlertDialog(
                                  context: context,
                                  message: state.errorMessage ?? '');
                            } else {
                              _stockObject = null;
                              _quantityController.clear();
                            }
                          } else {
                            showAlertDialog(
                                context: context,
                                message: localizations.select_item);
                          }
                        } else {
                          showAlertDialog(
                              context: context,
                              message: localizations.select_shop);
                        }
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
