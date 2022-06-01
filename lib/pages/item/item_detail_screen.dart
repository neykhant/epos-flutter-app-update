import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../components/elements/my_button.dart';
import '../../components/modules/my_app_bar.dart';
import '../../models/item_model.dart';
import '../../pages/item/item_form_screen.dart';
import '../../providers/item_provider.dart';
import '../../utility_methods.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Consumer<ItemProvider>(
      builder: (BuildContext context, state, child) {
        ItemModel item = state.item!;
        return Scaffold(
          appBar: MyAppBar(
            title: item.itemName,
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
                          item.categoryModel!.name,
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
                          item.itemName,
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
                        '${item.buyPrice} Ks',
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
                        '${item.salePrice} Ks',
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
                                ItemFormScreen(existedItems: item),
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
