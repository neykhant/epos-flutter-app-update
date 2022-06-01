import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/sale_items_model.dart';
import '../../providers/profit_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class SaleItemsShowScreen extends StatefulWidget {
  const SaleItemsShowScreen({Key? key}) : super(key: key);

  @override
  _SaleItemsShowScreenState createState() => _SaleItemsShowScreenState();
}

class _SaleItemsShowScreenState extends State<SaleItemsShowScreen> {
  String? startDate;
  String? endDate;
  bool _isLoading = false;
  SaleItemsModel? saleItemsObject;
  List<SaleItemsModel> _saleItemsList = [];
  List<String> itemNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final ProfitProvider profitProvider =
        Provider.of<ProfitProvider>(context, listen: false);
    await profitProvider.loadSaleItems(shopProvider.shop!.id);

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
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);
    final ProfitProvider profitProvider = Provider.of<ProfitProvider>(context);

    _saleItemsList = profitProvider.saleItems;

    itemNames.clear();
    for (var i = 0; i < _saleItemsList.length; i++) {
      itemNames.add(_saleItemsList[i].stock.itemModel.itemName);
    }

    List<SaleItemsModel> _usedSaleItemsList = saleItemsObject == null
        ? _saleItemsList
        : _saleItemsList
            .where((e) =>
                e.stock.itemModel.itemName ==
                saleItemsObject!.stock.itemModel.itemName)
            .toList();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    List<Widget> widgetItems = [
      MyButton(
        fontSize: 14.0, //16
        verticalPadding: 12.0, //15
        horizontalPadding: 18.0, //20
        label: startDate ?? localizations.start_date,
        onPressed: () async {
          if (_saleItemsList.isNotEmpty) {
            DateTime? _startDate = await showDatePicker(
              context: context,
              initialDate: _saleItemsList.last.day,
              firstDate: _saleItemsList.last.day,
              lastDate: _saleItemsList.first.day,
            );
            setState(() {
              startDate = _startDate.toString().substring(0, 10);
            });
          }
        },
        primary: Theme.of(context).primaryColor,
      ),
      const SizedBox(width: 10.0),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          '~',
          style: kTextStyle(size: 27.0),
        ),
      ),
      const SizedBox(width: 10.0),
      MyButton(
        fontSize: 14.0, //16
        verticalPadding: 12.0, //15
        horizontalPadding: 18.0, //20
        label: endDate ?? localizations.end_date,
        onPressed: () async {
          if (_saleItemsList.isNotEmpty) {
            DateTime? _endDate = await showDatePicker(
              context: context,
              initialDate: _saleItemsList.first.day,
              firstDate: _saleItemsList.last.day,
              lastDate: _saleItemsList.first.day,
            );
            setState(() {
              endDate = _endDate.toString().substring(0, 10);
            });
          }
        },
        primary: Theme.of(context).primaryColor,
      ),
    ];

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.sale_items,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widgetItems,
                ),
                const SizedBox(height: 20.0),
                MyButton(
                  fontSize: 14.0, //16
                  verticalPadding: 12.0, //15
                  horizontalPadding: 18.0, //20
                  label: localizations.check,
                  onPressed: () async {
                    await context.read<ProfitProvider>().loadSaleItemsByDate(
                        shopProvider.shop!.id, startDate ?? '', endDate ?? '');
                  },
                  primary: Theme.of(context).primaryColor,
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
                      for (var i = 0; i < _saleItemsList.length; i++) {
                        if (_saleItemsList[i].stock.itemModel.itemName ==
                            data) {
                          setState(() {
                            saleItemsObject = _saleItemsList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        saleItemsObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedSaleItemsList.length,
                    itemBuilder: (context, index) {
                      SaleItemsModel saleItem = _usedSaleItemsList[index];

                      return Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, //8
                            vertical: 10.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy').format(saleItem.day),
                                style: kTextStyle(size: 16.0),
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
                                    saleItem.stock.itemModel.itemName,
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
                                    '${saleItem.quantity}',
                                    style: kTextStyle(size: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localizations.total,
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
                                    '${saleItem.subtotal}',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
