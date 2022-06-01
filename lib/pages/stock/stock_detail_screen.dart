import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../components/elements/my_button.dart';
import '../../components/modules/my_app_bar.dart';
import '../../models/stock_model.dart';
import '../../pages/stock/stock_form_screen.dart';
import '../../providers/stock_provider.dart';
import '../../utility_methods.dart';

class StockDetailScreen extends StatelessWidget {
  const StockDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Consumer<StockProvider>(
      builder: (BuildContext context, state, child) {
        StockModel stock = state.stock!;
        return Scaffold(
          appBar: MyAppBar(
            title: stock.itemModel.itemName,
            fontSize: 18.0,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              width: 340,
              height: 360,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.item_category,
                        style: kTextStyle(size: 16.0),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '=',
                        style: kTextStyle(size: 16.0),
                      ),
                      const SizedBox(width: 15.0),
                      Flexible(
                        child: Text(
                          stock.itemModel.categoryModel!.name,
                          style: kTextStyle(size: 16.0),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.item_name,
                        style: kTextStyle(size: 16.0),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '=',
                        style: kTextStyle(),
                      ),
                      const SizedBox(width: 15.0),
                      Flexible(
                        child: Text(
                          stock.itemModel.itemName,
                          style: kTextStyle(size: 16.0),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.buy_price,
                        style: kTextStyle(size: 16.0),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '=',
                        style: kTextStyle(),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '${stock.itemModel.buyPrice} Ks',
                        style: kTextStyle(size: 16.0),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.sale_price,
                        style: kTextStyle(size: 16.0),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '=',
                        style: kTextStyle(),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '${stock.itemModel.salePrice} Ks',
                        style: kTextStyle(size: 16.0),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.quantity,
                        style: kTextStyle(size: 16.0),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '=',
                        style: kTextStyle(),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '${stock.quantity} (s)',
                        style: kTextStyle(size: 16.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: MyButton(
                      label: localizations.edit_item,
                      fontSize: 14.0, //16
                      verticalPadding: 12.0, //15
                      horizontalPadding: 18.0, //20
                      primary: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StockFormScreen(existedStock: stock),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
