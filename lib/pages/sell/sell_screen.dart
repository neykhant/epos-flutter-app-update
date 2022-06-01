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
import '../../models/category_model.dart';
import '../../models/customer_model.dart';
import '../../models/sale_model.dart';
import '../../models/single_sale_model.dart';
import '../../models/stock_model.dart';
import '../../print/big_print_screen.dart';
import '../../print/print_screen.dart';
import '../../providers/category_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/sale_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/stock_provider.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  bool _isLoading = false;

  final TextEditingController _customerNameController = TextEditingController();
  String customerName = '';

  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemCountController = TextEditingController();
  final TextEditingController _singleTotal = TextEditingController();
  List<SingleSaleModel> singleSaleList = [];

  StockModel? stockObject;

  int purchaseTotal = 0;
  int saleRecordTotal = 0;

  final TextEditingController _extraChargeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();

  int wholeTotal = 0;
  double credit = 0;
  double discount = 0;

  List<String> itemNames = [];
  List<StockModel> _stockList = [];

  List<String> customerNames = [];
  List<CustomerModel> _customerList = [];

  CategoryModel? categoryObject;
  List<String> categoryNames = [];
  List<CategoryModel> _categoryList = [];

  bool _isInit = false;

  void loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final CustomerProvider customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    await customerProvider.loadCustomers(shopProvider.shop!.id);
    _customerList = customerProvider.customers;

    customerNames.clear();
    for (var i = 0; i < _customerList.length; i++) {
      customerNames.add(_customerList[i].name);
    }

    final StockProvider stockProvider =
        Provider.of<StockProvider>(context, listen: false);
    await stockProvider.loadStocks(shopProvider.shop!.id);

    _stockList = stockProvider.stocks;

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
  void initState() {
    _discountController.text = "0";
    super.initState();
  }

  @override
  void dispose() {
    _itemPriceController.dispose();
    _itemCountController.dispose();
    _singleTotal.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  void addSingleSale() {
    if (_singleTotal.text.trim() != '' &&
        _itemCountController.text.trim() != '') {
      if (int.parse(_itemCountController.text.trim()) > stockObject!.quantity) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("သတိပေးချက်"),
              content: Text(
                "အရေအတွက် မလုံလောက်ပါ",
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
      } else {
        SingleSaleModel _singleSale = SingleSaleModel(
          itemPrice: int.parse(_itemPriceController.text),
          quantity: int.parse(_itemCountController.text),
          totalPrice: int.parse(_singleTotal.text),
          stock: stockObject!,
        );
        saleRecordTotal += int.parse(_singleTotal.text);
        purchaseTotal += int.parse(_itemCountController.text) *
            stockObject!.itemModel.buyPrice;
        setState(() {
          singleSaleList.add(_singleSale);
          _itemPriceController.clear();
          _itemCountController.clear();
          _singleTotal.clear();
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("သတိပေးချက်"),
            content: Text(
              "ရောင်းရန်ထည့်ပါ",
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

    if (categoryObject != null) {
      itemNames.clear();
      for (var i = 0; i < _stockList.length; i++) {
        if (_stockList[i].itemModel.categoryModel!.id == categoryObject!.id) {
          itemNames.add(_stockList[i].itemModel.itemName);
        }
      }
    } else {
      itemNames.clear();
      for (var i = 0; i < _stockList.length; i++) {
        itemNames.add(_stockList[i].itemModel.itemName);
      }
    }

    List<TableRow> _showTableRow(BuildContext context) {
      List<TableRow> tableRows = [];

      for (SingleSaleModel element in singleSaleList) {
        tableRows.add(
          TableRow(
            children: <Widget>[
              TableCellWidget(
                child: Text(
                  element.stock.itemModel.itemName,
                  style: kTextStyle(size: 16.0),
                ),
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    singleSaleList.remove(element);
                    saleRecordTotal -= element.totalPrice;
                    purchaseTotal -= element.itemPrice;
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

    double discountAmount = saleRecordTotal - discount;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.sell_screen,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0, //18
      ),
      drawer: const MyDrawer(),
      body: Consumer<SaleProvider>(
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
                      hint: localizations.select_category,
                      mode: Mode.MENU,
                      items: categoryNames.toSet().toList(),
                      showClearButton: true,
                      showSearchBox: true,
                      onChanged: (String? data) {
                        if (data == null) {
                          setState(() {
                            categoryObject = null;
                          });
                        } else {
                          for (var i = 0; i < _categoryList.length; i++) {
                            if (_categoryList[i].name == data) {
                              setState(() {
                                categoryObject = _categoryList[i];
                              });
                            }
                          }
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
                        for (var i = 0; i < _stockList.length; i++) {
                          if (_stockList[i].itemModel.itemName == data) {
                            setState(() {
                              stockObject = _stockList[i];
                              _itemPriceController.text =
                                  _stockList[i].itemModel.salePrice.toString();
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
                            _singleTotal.text = total.toString();
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
                        if (stockObject != null && value.trim() != "") {
                          int total = int.parse(_itemPriceController.text) *
                              int.parse(value);
                          setState(() {
                            _singleTotal.text = total.toString();
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
                      controller: _singleTotal,
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
                      horizontalPadding: 20.0,
                      onPressed: addSingleSale,
                      primary: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${localizations.items} - ${singleSaleList.length}',
                          style: kTextStyle(),
                        ),
                      ],
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
                          '$saleRecordTotal Ks',
                          style: kTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      controller: _discountController,
                      onChanged: (String value) {
                        if (value.trim() != "") {
                          setState(() {
                            discount =
                                (double.parse(_discountController.text) / 100) *
                                    saleRecordTotal;
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintText: localizations.discount,
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
                          '${localizations.discount_amount} = ',
                          style: kTextStyle(),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          '${discount.toStringAsFixed(2)} Ks',
                          style: kTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${localizations.final_total} = ',
                          style: kTextStyle(),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          '${saleRecordTotal - discount} Ks',
                          style: kTextStyle(),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 30.0),
                    // TextField(
                    //   controller: _extraChargeController,
                    //   onChanged: (String value) {
                    //     if (value.trim() != "") {
                    //       setState(() {
                    //         wholeTotal = saleRecordTotal + int.parse(value);
                    //       });
                    //     }
                    //   },
                    //   keyboardType: TextInputType.number,
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     hoverColor: Colors.white,
                    //     hintText: localizations.extra_charges,
                    //     focusedBorder: const OutlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.black),
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderSide: const BorderSide(color: Colors.black),
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 10.0),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     Text(
                    //       '${localizations.final_total} = ',
                    //       style: kTextStyle(),
                    //     ),
                    //     const SizedBox(width: 5.0),
                    //     Text(
                    //       '$wholeTotal Ks',
                    //       style: kTextStyle(),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _paidController,
                      onChanged: (String value) {
                        if (value.trim() != "" &&
                            discountAmount >= int.parse(value)) {
                          setState(() {
                            credit = discountAmount - int.parse(value);
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
                          '${credit.toStringAsFixed(2)} Ks',
                          style: kTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _customerNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintText: localizations.customer_name,
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
                      hint: localizations.select_customer,
                      mode: Mode.MENU,
                      items: customerNames,
                      showClearButton: true,
                      showSearchBox: true,
                      onChanged: (String? data) {
                        if (data != null) {
                          for (var i = 0; i < _customerList.length; i++) {
                            if (_customerList[i].name == data) {
                              setState(() {
                                customerName = _customerList[i].name;
                              });
                            }
                          }
                        } else {
                          setState(() {
                            customerName = '';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    MyButton(
                      label: '${localizations.save}-3"',
                      fontSize: 16.0, //18
                      verticalPadding: 12.0, //15
                      horizontalPadding: 20.0,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (singleSaleList.isNotEmpty &&
                            _paidController.text != '') {
                          if (customerName != '' &&
                              _customerNameController.text != '') {
                            showAlertDialog(
                                context: context,
                                message: localizations.alert_error_customer);
                          } else {
                            String? useCustomerName = '-';

                            useCustomerName = _customerNameController.text != ""
                                ? _customerNameController.text
                                : useCustomerName;
                            useCustomerName = customerName != ""
                                ? customerName
                                : useCustomerName;
                            if (_customerNameController.text != "") {
                              useCustomerName = _customerNameController.text;
                            } else {
                              useCustomerName = customerName == ""
                                  ? useCustomerName
                                  : customerName;
                            }

                            List<Map<String, dynamic>> singleSales = [];
                            for (SingleSaleModel singleSale in singleSaleList) {
                              singleSales.add({
                                'stock_id': singleSale.stock.id,
                                'price': singleSale.itemPrice,
                                'quantity': singleSale.quantity,
                                'subtotal': singleSale.totalPrice,
                              });
                            }

                            Map<String, dynamic> sale = {
                              'customer_name': useCustomerName,
                              'purchase_total': purchaseTotal,
                              'sale_record_total': saleRecordTotal,
                              'extra_charges': 0, // if necessary
                              'whole_total': saleRecordTotal,
                              'discount': _discountController.text,
                              'paid': int.parse(_paidController.text),
                              'shop_id': shopProvider.shop!.id,
                              'single_sales': singleSales,
                            };

                            await context.read<SaleProvider>().postSale(sale);

                            if (state.errorMessage != null) {
                              showAlertDialog(
                                  context: context,
                                  message: state.errorMessage ?? '');
                            } else {
                              SaleModel sale = state.sale!;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrintScreen(
                                    singles: sale.singleSales,
                                    name: sale.customerName,
                                    total: sale.saleRecordTotal.toString(),
                                    extraCharges: sale.extraCharges.toString(),
                                    discount: sale.discount,
                                    finalTotal: sale.finalTotal,
                                    paid: sale.paid.toString(),
                                    credit: sale.credit.toStringAsFixed(2),
                                    createdAt: sale.createdAt,
                                    invoiceNumber: sale.id.toString(),
                                    isBuy: false,
                                  ),
                                ),
                              );
                              singleSaleList.clear();
                              purchaseTotal = 0;
                              saleRecordTotal = 0;
                              _extraChargeController.clear();
                              _paidController.clear();
                              credit = 0;
                              wholeTotal = 0;
                              discount = 0;
                              _discountController.text = '0';
                              customerName = '';
                              _customerNameController.clear();
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
                      fontSize: 16.0, //18
                      verticalPadding: 12.0, //15
                      horizontalPadding: 20.0,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (singleSaleList.isNotEmpty &&
                            _paidController.text != '') {
                          if (customerName != '' &&
                              _customerNameController.text != '') {
                            showAlertDialog(
                                context: context,
                                message: localizations.alert_error_customer);
                          } else {
                            String? useCustomerName = '-';

                            useCustomerName = _customerNameController.text != ""
                                ? _customerNameController.text
                                : useCustomerName;
                            useCustomerName = customerName != ""
                                ? customerName
                                : useCustomerName;
                            if (_customerNameController.text != "") {
                              useCustomerName = _customerNameController.text;
                            } else {
                              useCustomerName = customerName == ""
                                  ? useCustomerName
                                  : customerName;
                            }

                            List<Map<String, dynamic>> singleSales = [];
                            for (SingleSaleModel singleSale in singleSaleList) {
                              singleSales.add({
                                'stock_id': singleSale.stock.id,
                                'price': singleSale.itemPrice,
                                'quantity': singleSale.quantity,
                                'subtotal': singleSale.totalPrice,
                              });
                            }

                            Map<String, dynamic> sale = {
                              'customer_name': useCustomerName,
                              'purchase_total': purchaseTotal,
                              'sale_record_total': saleRecordTotal,
                              'extra_charges': 0, // if necessary
                              'whole_total': saleRecordTotal,
                              'discount': _discountController.text,
                              'paid': int.parse(_paidController.text),
                              'shop_id': shopProvider.shop!.id,
                              'single_sales': singleSales,
                            };

                            await context.read<SaleProvider>().postSale(sale);

                            if (state.errorMessage != null) {
                              showAlertDialog(
                                  context: context,
                                  message: state.errorMessage ?? '');
                            } else {
                              SaleModel sale = state.sale!;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BigPrintScreen(
                                    singles: sale.singleSales,
                                    name: sale.customerName,
                                    total: sale.saleRecordTotal.toString(),
                                    extraCharges: sale.extraCharges.toString(),
                                    discount: sale.discount,
                                    finalTotal: sale.finalTotal,
                                    paid: sale.paid.toString(),
                                    credit: sale.credit.toStringAsFixed(2),
                                    createdAt: sale.createdAt,
                                    invoiceNumber: sale.id.toString(),
                                    isBuy: false,
                                  ),
                                ),
                              );
                              singleSaleList.clear();
                              purchaseTotal = 0;
                              saleRecordTotal = 0;
                              _extraChargeController.clear();
                              _paidController.clear();
                              credit = 0;
                              wholeTotal = 0;
                              discount = 0;
                              _discountController.text = '0';
                              customerName = '';
                              _customerNameController.clear();
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
                      fontSize: 16.0, //18
                      verticalPadding: 12.0, //15
                      horizontalPadding: 20.0,
                      onPressed: () {
                        setState(() {
                          singleSaleList.clear();
                          purchaseTotal = 0;
                          saleRecordTotal = 0;
                          _extraChargeController.clear();
                          _paidController.clear();
                          credit = 0;
                          wholeTotal = 0;
                          discount = 0;
                          _discountController.text = '0';
                          customerName = '';
                          _customerNameController.clear();
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
