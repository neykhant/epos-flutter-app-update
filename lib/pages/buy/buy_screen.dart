import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../../components/tables/table_header_cell.dart';
import '../../../utility_methods.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../components/tables/table_cell.dart';
import '../../models/buy_model.dart';
import '../../models/item_model.dart';
import '../../models/merchant_model.dart';
import '../../models/single_buy_model.dart';
import '../../print/big_print_screen.dart';
import '../../print/print_screen.dart';
import '../../providers/buy_provider.dart';
import '../../providers/item_provider.dart';
import '../../providers/merchant_provider.dart';
import '../../providers/shop_provider.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({
    Key? key,
  }) : super(key: key);

  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  bool _isLoading = false;

  final TextEditingController _merchantNameController = TextEditingController();
  String merchantName = '';

  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemCountController = TextEditingController();
  final TextEditingController _singleTotalController = TextEditingController();
  ItemModel? itemObject;
  List<SingleBuyModel> singleBuyList = [];

  final TextEditingController _paidController = TextEditingController();

  int wholeTotal = 0;
  int credit = 0;

  List<String> itemNames = [];
  List<ItemModel> _itemList = [];

  List<String> merchantNames = [];
  List<MerchantModel> _merchantList = [];

  bool _isInit = false;

  void loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final ItemProvider itemProvider =
        Provider.of<ItemProvider>(context, listen: false);
    await itemProvider.loadItems();

    _itemList = itemProvider.items;

    itemNames.clear();
    for (var i = 0; i < _itemList.length; i++) {
      itemNames.add(_itemList[i].itemName);
    }

    final MerchantProvider merchantProvider =
        Provider.of<MerchantProvider>(context, listen: false);
    await merchantProvider.loadMerchants(shopProvider.shop!.id);
    _merchantList = merchantProvider.merchants;

    merchantNames.clear();
    for (var i = 0; i < _merchantList.length; i++) {
      merchantNames.add(_merchantList[i].name);
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
  void dispose() {
    _itemPriceController.dispose();
    _itemCountController.dispose();
    _singleTotalController.dispose();
    _merchantNameController.dispose();
    super.dispose();
  }

  void addSingleSale() {
    if (itemObject != null &&
        _itemPriceController.text.trim() != '' &&
        _singleTotalController.text.trim() != '' &&
        _itemCountController.text.trim() != '') {
      SingleBuyModel _singleBuy = SingleBuyModel(
        itemPrice: int.parse(_itemPriceController.text),
        quantity: int.parse(_itemCountController.text),
        totalPrice: int.parse(_singleTotalController.text),
        item: itemObject!,
      );
      wholeTotal += int.parse(_singleTotalController.text);

      setState(() {
        singleBuyList.add(_singleBuy);
        itemObject = null;
        _itemPriceController.clear();
        _itemCountController.clear();
        _singleTotalController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("သတိပေးချက်"),
            content: Text(
              "ဝယ်ရန်ထည့်ပါ",
              style: kTextStyle(size: 16.0),
            ),
            actions: [
              TextButton(
                child: const Text("ရှေ့ဆက်မည်"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    List<TableRow> _showTableRow(BuildContext context) {
      List<TableRow> tableRows = [];

      for (SingleBuyModel element in singleBuyList) {
        tableRows.add(
          TableRow(
            children: <Widget>[
              TableCellWidget(
                child: Text(
                  element.item.itemName,
                  style: kTextStyle(size: 16.0),
                ),
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    singleBuyList.remove(element);
                    wholeTotal -= element.totalPrice;
                  });
                },
                child: TableCellWidget(
                  child: Text(
                    '${element.itemPrice} Ks',
                    style: kTextStyle(size: 16.0),
                  ),
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${element.quantity}',
                  style: kTextStyle(size: 16.0),
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${element.totalPrice} Ks',
                  style: kTextStyle(size: 16.0),
                ),
              ),
            ],
          ),
        );
      }

      return tableRows;
    }

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.buy_screen,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0, //18
      ),
      drawer: const MyDrawer(),
      body: Consumer<BuyProvider>(
        builder: (BuildContext context, state, child) {
          return ProgressHUD(
            inAsyncCall: _isLoading,
            child: Padding(
              padding: kPadding,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                              itemObject = _itemList[i];
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _itemPriceController,
                      onChanged: (String value) {
                        if (_itemCountController.text != '' &&
                            value.trim() != "") {
                          int total = int.parse(_itemCountController.text) *
                              int.parse(value);
                          setState(() {
                            _singleTotalController.text = total.toString();
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintText: localizations.price,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _itemCountController,
                      onChanged: (String value) {
                        if (itemObject != null && value.trim() != "") {
                          int total = int.parse(_itemPriceController.text) *
                              int.parse(value);
                          setState(() {
                            _singleTotalController.text = total.toString();
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintText: localizations.quantity,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _singleTotalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintText: localizations.sub_total,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    MyButton(
                      label: 'Add Row',
                      fontSize: 14.0, //16
                      verticalPadding: 12.0, //15
                      horizontalPadding: 18.0, //20
                      onPressed: addSingleSale,
                      primary: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 30.0),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          decoration: kTableRowBoxDecoration.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                          children: <Widget>[
                            TableHeadingCell(
                              tableHeight: 70.0,
                              fontSize: 14.0, //16
                              label: localizations.items,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                              ),
                            ),
                            TableHeadingCell(
                              tableHeight: 70.0,
                              label: localizations.price,
                              fontSize: 14.0, //16
                            ),
                            TableHeadingCell(
                              tableHeight: 70.0,
                              label: localizations.quantity,
                              fontSize: 14.0, //16
                            ),
                            TableHeadingCell(
                              tableHeight: 70.0,
                              fontSize: 14.0, //16
                              label: localizations.sub_total,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                          ],
                        ),
                        ..._showTableRow(context),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${localizations.total} = ',
                          style: kTextStyle(),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          '$wholeTotal Ks',
                          style: kTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      controller: _paidController,
                      onChanged: (String value) {
                        if (value.trim() != "" &&
                            wholeTotal >= int.parse(value)) {
                          setState(() {
                            credit = wholeTotal - int.parse(value);
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintText: localizations.paid_price,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${localizations.credit} = ',
                          style: kTextStyle(),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          '$credit Ks',
                          style: kTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _merchantNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintText: localizations.merchant_name,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    DropdownSearch<String>(
                      // ignore: deprecated_member_use
                      hint: localizations.select_merchants,
                      mode: Mode.MENU,
                      items: merchantNames,
                      showClearButton: true,
                      showSearchBox: true,
                      onChanged: (String? data) {
                        if (data != null) {
                          for (var i = 0; i < _merchantList.length; i++) {
                            if (_merchantList[i].name == data) {
                              setState(() {
                                merchantName = _merchantList[i].name;
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
                    const SizedBox(height: 20.0),
                    MyButton(
                      label: '${localizations.save}-3"',
                      fontSize: 14.0, //16
                      verticalPadding: 12.0, //15
                      horizontalPadding: 18.0, //20
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (singleBuyList.isNotEmpty &&
                            _paidController.text != '') {
                          if (merchantName != '' &&
                              _merchantNameController.text != '') {
                            showAlertDialog(
                                context: context,
                                message: 'Fill merchant name.');
                          } else {
                            String? useMerchantName = 'Default';

                            useMerchantName = _merchantNameController.text != ""
                                ? _merchantNameController.text
                                : useMerchantName;
                            useMerchantName = merchantName != ""
                                ? merchantName
                                : useMerchantName;
                            if (_merchantNameController.text != "") {
                              useMerchantName = _merchantNameController.text;
                            } else {
                              useMerchantName = merchantName == ""
                                  ? useMerchantName
                                  : merchantName;
                            }

                            List<Map<String, dynamic>> singleBuys = [];
                            for (SingleBuyModel singleBuy in singleBuyList) {
                              singleBuys.add({
                                'item_id': singleBuy.item.id,
                                'price': singleBuy.itemPrice,
                                'quantity': singleBuy.quantity,
                                'subtotal': singleBuy.totalPrice,
                              });
                            }

                            Map<String, dynamic> buy = {
                              'merchant_name': useMerchantName,
                              'whole_total': wholeTotal,
                              'paid': int.parse(_paidController.text),
                              'shop_id': shopProvider.shop!.id,
                              'single_buys': singleBuys,
                            };

                            await context.read<BuyProvider>().postBuy(buy);

                            if (state.errorMessage != null) {
                              showAlertDialog(
                                  context: context,
                                  message: state.errorMessage ?? '');
                            } else {
                              BuyModel buy = state.buy!;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrintScreen(
                                    singles: buy.singleBuys,
                                    name: buy.merchantName,
                                    total: buy.wholeTotal.toString(),
                                    extraCharges: "0",
                                    discount: 0,
                                    finalTotal: 0.0,
                                    paid: buy.paid.toString(),
                                    credit: buy.credit.toString(),
                                    createdAt: buy.createdAt,
                                    invoiceNumber: buy.id.toString(),
                                    isBuy: true,
                                  ),
                                ),
                              );

                              setState(() {
                                itemObject = null;
                                singleBuyList = [];
                                merchantName = '';
                                wholeTotal = 0;
                                _paidController.clear();
                                credit = 0;
                                _merchantNameController.clear();
                              });
                            }
                          }
                        } else {
                          showAlertDialog(
                              context: context,
                              message: localizations.sell_alert);
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      primary: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 20.0),
                    MyButton(
                      label: '${localizations.save}-4"',
                      fontSize: 14.0, //16
                      verticalPadding: 12.0, //15
                      horizontalPadding: 18.0, //20
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (singleBuyList.isNotEmpty &&
                            _paidController.text != '') {
                          if (merchantName != '' &&
                              _merchantNameController.text != '') {
                            showAlertDialog(
                                context: context,
                                message: 'Fill merchant name.');
                          } else {
                            String? useMerchantName = 'Default';

                            useMerchantName = _merchantNameController.text != ""
                                ? _merchantNameController.text
                                : useMerchantName;
                            useMerchantName = merchantName != ""
                                ? merchantName
                                : useMerchantName;
                            if (_merchantNameController.text != "") {
                              useMerchantName = _merchantNameController.text;
                            } else {
                              useMerchantName = merchantName == ""
                                  ? useMerchantName
                                  : merchantName;
                            }

                            List<Map<String, dynamic>> singleBuys = [];
                            for (SingleBuyModel singleBuy in singleBuyList) {
                              singleBuys.add({
                                'item_id': singleBuy.item.id,
                                'price': singleBuy.itemPrice,
                                'quantity': singleBuy.quantity,
                                'subtotal': singleBuy.totalPrice,
                              });
                            }

                            Map<String, dynamic> buy = {
                              'merchant_name': useMerchantName,
                              'whole_total': wholeTotal,
                              'paid': int.parse(_paidController.text),
                              'shop_id': shopProvider.shop!.id,
                              'single_buys': singleBuys,
                            };

                            await context.read<BuyProvider>().postBuy(buy);

                            if (state.errorMessage != null) {
                              showAlertDialog(
                                  context: context,
                                  message: state.errorMessage ?? '');
                            } else {
                              BuyModel buy = state.buy!;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BigPrintScreen(
                                    singles: buy.singleBuys,
                                    name: buy.merchantName,
                                    total: buy.wholeTotal.toString(),
                                    extraCharges: "0",
                                    discount: 0,
                                    finalTotal: 0.0,
                                    paid: buy.paid.toString(),
                                    credit: buy.credit.toString(),
                                    createdAt: buy.createdAt,
                                    invoiceNumber: buy.id.toString(),
                                    isBuy: true,
                                  ),
                                ),
                              );

                              setState(() {
                                itemObject = null;
                                singleBuyList = [];
                                merchantName = '';
                                wholeTotal = 0;
                                _paidController.clear();
                                credit = 0;
                                _merchantNameController.clear();
                              });
                            }
                          }
                        } else {
                          showAlertDialog(
                              context: context,
                              message: localizations.sell_alert);
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      primary: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 30.0),
                    MyButton(
                      label: localizations.sell_screen_clean,
                      fontSize: 14.0, //16
                      verticalPadding: 12.0, //15
                      horizontalPadding: 18.0, //20
                      onPressed: () {
                        setState(() {
                          itemObject = null;
                          singleBuyList = [];
                          merchantName = '';
                          wholeTotal = 0;
                          _paidController.clear();
                          credit = 0;
                          _merchantNameController.clear();
                        });
                      },
                      primary: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
