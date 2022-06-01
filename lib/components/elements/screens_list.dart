import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/stock_provider.dart';
import '../../utility_methods.dart';

class ScreensList extends StatelessWidget {
  ScreensList({Key? key, this.fontSize = 18.0}) : super(key: key);
  final double fontSize;

  final List<String> pages = <String>[
    'အရောင်းစာရင်းချုပ်',
    'အရောင်း စာမျက်နှာ',
    'ပစ္စည်းစာရင်း',
    'ဈေးနှုန်း အပြောင်းအလဲများ',
    'ဆိုင်အချက်အလက်ပြ စာမျက်နှာ',
  ];
  final List<String> routes = <String>[
    '/records_list',
    '/sell_screen',
    '/item_show',
    '/price_track',
    '/shop_info',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kPadding,
      width: 320,
      height: 430,
      child: Card(
        elevation: 0,
        shape: kRoundedRectangleBorder,
        color: Theme.of(context).colorScheme.secondary,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15.0),
          child: ScreensListButtons(
            pages: pages,
            routes: routes,
            verticalPadding: 7.0,
            fontSize: fontSize,
            horizontalPadding: 15.0,
          ),
        ),
      ),
    );
  }
}

class ScreensListButtons extends StatelessWidget {
  const ScreensListButtons({
    Key? key,
    required this.pages,
    required this.routes,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.fontSize,
  }) : super(key: key);

  final List<String> pages;
  final List<String> routes;
  final double verticalPadding;
  final double horizontalPadding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final StockProvider stockProvider = Provider.of<StockProvider>(context);

    return ListView.builder(
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return routes[index] == '/low_items' &&
                stockProvider.lowStocks.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Card(
                  elevation: 0,
                  shape: kRoundedRectangleBorder,
                  color: const Color(0xFFDC0505),
                  child: ListTile(
                    title: Text(
                      pages[index],
                      style: kTextStyle(size: fontSize).copyWith(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        routes[index],
                      );
                    },
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Card(
                  elevation: 0,
                  shape: kRoundedRectangleBorder,
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    title: Text(
                      pages[index],
                      style: kTextStyle(size: fontSize).copyWith(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        routes[index],
                      );
                    },
                  ),
                ),
              );
      },
    );
  }
}
