import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/my_form_wrapper.dart';
import '../../components/elements/my_text_form_field.dart';
import '../../components/elements/progress_hud.dart';
import '../../components/modules/my_app_bar.dart';
import '../../models/category_model.dart';
import '../../models/item_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/item_provider.dart';
import '../../utility_methods.dart';

class ItemFormScreen extends StatefulWidget {
  final ItemModel? existedItems;
  const ItemFormScreen({
    Key? key,
    this.existedItems,
  }) : super(key: key);

  @override
  _ItemFormScreenState createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemCodeController = TextEditingController();
  CategoryModel? _categoryObject;
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _buyPriceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();

  List<CategoryModel> _categoryList = [];
  List<String> categoryNames = [];
  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.loadCategories();

    _categoryList = categoryProvider.categories;

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

  // carry data from existing item for item editing function
  @override
  void initState() {
    if (widget.existedItems != null) {
      _itemCodeController.text = widget.existedItems!.code;
      _categoryObject = widget.existedItems!.categoryModel;
      _itemNameController.text = widget.existedItems!.itemName;
      _salePriceController.text = widget.existedItems!.salePrice.toString();
      _buyPriceController.text = widget.existedItems!.buyPrice.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _itemCodeController.dispose();
    _itemNameController.dispose();
    _salePriceController.dispose();
    _buyPriceController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _itemCodeController.text = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: widget.existedItems == null
            ? localizations.create_new_item
            : localizations.edit_item,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        child: MyFormWrapper(
          formWidth: 340.0,
          formKey: _formKey,
          height: 700.0,
          children: [
            MyButton(
              label: 'Scan with phone',
              fontSize: 14.0, //16
              verticalPadding: 12.0, //15
              horizontalPadding: 18.0, //20
              onPressed: scanBarcodeNormal,
              primary: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 10.0),
            Text(
              localizations.item_code,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _itemCodeController,
              decoration: kInputDecoration,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_item_code;
                }
                return null;
              },
            ),
            Text(
              localizations.item_category,
              style: kTextStyle(size: 16.0),
            ),
            DropdownSearch<String>(
              // ignore: deprecated_member_use
              hint: localizations.select_category,
              mode: Mode.MENU,
              items: categoryNames,
              showClearButton: true,
              showSearchBox: true,
              onChanged: (String? data) {
                for (var i = 0; i < _categoryList.length; i++) {
                  if (_categoryList[i].name == data) {
                    setState(() {
                      _categoryObject = _categoryList[i];
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
            MyTextFormField(
              controller: _itemNameController,
              decoration: kInputDecoration,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_item_name;
                }
                return null;
              },
            ),
            Text(
              localizations.buy_price,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _buyPriceController,
              decoration: kInputDecoration,
              keyboardType: TextInputType.number,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_buy_price;
                }
                if (int.tryParse(value.trim()) == null) {
                  return localizations.enter_number;
                }
                return null;
              },
            ),
            Text(
              localizations.sale_price,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _salePriceController,
              decoration: kInputDecoration,
              keyboardType: TextInputType.number,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_sale_price;
                }
                if (int.tryParse(value.trim()) == null) {
                  return localizations.enter_number;
                }
                return null;
              },
            ),
            Consumer<ItemProvider>(
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
                        if (_categoryObject != null) {
                          if (widget.existedItems == null) {
                            Map<String, dynamic> item = {
                              'code': _itemCodeController.text,
                              'name': _itemNameController.text,
                              'buy_price': int.parse(_buyPriceController.text),
                              'sale_price':
                                  int.parse(_salePriceController.text),
                              'category_id': _categoryObject!.id,
                            };

                            await context.read<ItemProvider>().postItem(item);

                            if (state.errorMessage != null) {
                              showAlertDialog(
                                  context: context,
                                  message: state.errorMessage ?? '');
                            } else {
                              _itemCodeController.clear();
                              _categoryObject = null;
                              _itemNameController.clear();
                              _salePriceController.clear();
                              _buyPriceController.clear();
                            }
                          } else {
                            Map<String, dynamic> item = {
                              'code': _itemCodeController.text,
                              'name': _itemNameController.text,
                              'buy_price': int.parse(_buyPriceController.text),
                              'sale_price':
                                  int.parse(_salePriceController.text),
                              'category_id': _categoryObject!.id,
                            };

                            await context
                                .read<ItemProvider>()
                                .updateItem(widget.existedItems!.id, item);

                            if (state.errorMessage != null) {
                              showAlertDialog(
                                  context: context,
                                  message: state.errorMessage ?? '');
                            } else {
                              Navigator.of(context).pushNamed('/items');
                            }
                          }
                        } else {
                          showAlertDialog(
                            context: context,
                            message: localizations.select_category,
                          );
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
