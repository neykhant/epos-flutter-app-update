import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/my_form_wrapper.dart';
import '../../components/elements/my_text_form_field.dart';
import '../../components/elements/progress_hud.dart';
import '../../components/modules/my_app_bar.dart';
import '../../models/item_model.dart';
import '../../models/stock_model.dart';
import '../../providers/item_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/stock_provider.dart';
import '../../utility_methods.dart';

class StockFormScreen extends StatefulWidget {
  final StockModel? existedStock;
  const StockFormScreen({
    Key? key,
    this.existedStock,
  }) : super(key: key);

  @override
  _StockFormScreenState createState() => _StockFormScreenState();
}

class _StockFormScreenState extends State<StockFormScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ItemModel? _itemObject;
  final TextEditingController _quantityController = TextEditingController();

  List<ItemModel> _itemList = [];
  List<String> itemNames = [];
  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ItemProvider itemProvider =
        Provider.of<ItemProvider>(context, listen: false);
    await itemProvider.loadItems();

    _itemList = itemProvider.items;

    for (var i = 0; i < _itemList.length; i++) {
      itemNames.add(_itemList[i].itemName);
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

  // carry data from existing item for item editing function
  @override
  void initState() {
    if (widget.existedStock != null) {
      _itemObject = widget.existedStock!.itemModel;
      _quantityController.text = '0';
    }
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        title: widget.existedStock == null
            ? localizations.create_stock
            : localizations.edit_stock,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        child: MyFormWrapper(
          formWidth: 340.0,
          formKey: _formKey,
          height: 300.0,
          children: [
            Text(
              localizations.item_name,
              style: kTextStyle(size: 16.0),
            ),
            DropdownSearch<String>(
              // ignore: deprecated_member_use
              hint: localizations.select_item,
              mode: Mode.MENU,
              items: itemNames,
              showClearButton: true,
              showSearchBox: true,
              onChanged: (String? data) {
                for (var i = 0; i < _itemList.length; i++) {
                  if (_itemList[i].itemName == data) {
                    setState(() {
                      _itemObject = _itemList[i];
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
              keyboardType: TextInputType.number,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_quantity;
                }
                if (int.tryParse(value.trim()) == null) {
                  return localizations.enter_number;
                }
                return null;
              },
            ),
            Consumer<StockProvider>(
              builder: (BuildContext context, state, index) {
                return Center(
                  child: MyButton(
                    label: localizations.save,
                    fontSize: 14.0, //16
                    verticalPadding: 12.0, //15
                    horizontalPadding: 18.0, //20
                    primary: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        if (_itemObject != null) {
                          if (widget.existedStock == null) {
                            Map<String, dynamic> stock = {
                              'shop_id': shopProvider.shop!.id,
                              'item_id': _itemObject!.id,
                              'quantity': int.parse(_quantityController.text),
                            };

                            await context
                                .read<StockProvider>()
                                .postStock(stock);

                            if (state.errorMessage != null) {
                              showAlertDialog(
                                  context: context,
                                  message: state.errorMessage ?? '');
                            } else {
                              _itemObject = null;
                              _quantityController.clear();
                            }
                          } else {
                            Map<String, dynamic> stock = {
                              'shop_id': shopProvider.shop!.id,
                              'item_id': _itemObject!.id,
                              'quantity': int.parse(_quantityController.text),
                            };

                            await context
                                .read<StockProvider>()
                                .updateStock(widget.existedStock!.id, stock);

                            if (state.errorMessage != null) {
                              showAlertDialog(
                                  context: context,
                                  message: state.errorMessage ?? '');
                            } else {
                              Navigator.of(context).pushNamed('/stocks');
                            }
                          }
                        } else {
                          showAlertDialog(
                              context: context,
                              message: localizations.select_item);
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
