import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../elements/screens_list.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    final double screenButtonFontSize = deviceWidth < 500 ? 16.0 : 18.0;

    AppLocalizations localizations = AppLocalizations.of(context)!;

    final List<String> pages = <String>[
      localizations.shop_list,
      localizations.sell_screen,
      localizations.sells,
      localizations.sale_return,
      localizations.categories,
      localizations.items,
      localizations.stocks,
      localizations.all_stocks,
      localizations.price_track,
      localizations.daily,
      localizations.monthly,
      localizations.yearly,
      // localizations.sale_items,
      // localizations.item_gross_profit,
      localizations.profit,
      // localizations.credits,
      localizations.customers,
      // localizations.merchants,
      // localizations.buy_screen,
      // localizations.buys,
      // localizations.buy_credits,
      // localizations.damage_items,
      localizations.expenses,
      // localizations.item_transfers,
      localizations.low_items,
      localizations.more_sale_items,
      localizations.shop_info,
      'Terms & Conditions',
    ];
    final List<String> routes = <String>[
      '/shops',
      '/sell_screen',
      '/sells',
      '/sell_returns',
      '/categories',
      '/items',
      '/stocks',
      '/all_stocks',
      '/price_tracks',
      '/daily',
      '/monthly',
      '/yearly',
      // '/sale_items',
      // '/gross-profit-item',
      '/profit',
      // '/credits',
      '/customers',
      // '/merchants',
      // '/buy_screen',
      // '/buys',
      // '/buy_credits',
      // '/damage_items',
      '/expenses',
      // '/item_transfers',
      '/low_items',
      '/more_sale_items',
      '/shop_info',
      '/terms_and_conditions',
    ];

    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            height: 120,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? 550
                : 420,
            child: ScreensListButtons(
              pages: pages,
              routes: routes,
              verticalPadding: 5.0,
              horizontalPadding: 7.0,
              fontSize: screenButtonFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
