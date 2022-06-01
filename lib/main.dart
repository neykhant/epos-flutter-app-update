import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../pages/shop/shop_detail_screen.dart';
import '../pages/terms_and_conditions.dart';
import '../pages/item/more_sale_item_show_screen.dart';
import 'pages/stock/low_item_show_screen.dart';
import '../pages/profit/profit_show_screen.dart';
import '../providers/sale_return_item_provider.dart';
import '../pages/stock/stock_form_screen.dart';
import '../providers/profit_provider.dart';
import '../pages/summy/monthly_show_screen.dart';
import '../providers/monthly_provider.dart';
import '../pages/summy/yearly_show_screen.dart';
import '../providers/yearly_provider.dart';
import '../pages/summy/daily_show_screen.dart';
import '../providers/daily_provider.dart';
import '../pages/expense/expense_form_screen.dart';
import '../pages/expense/expense_show_screen.dart';
import '../providers/expense_provider.dart';
import '../pages/damage_item/damage_item_show_screen.dart';
import '../providers/damage_item_provider.dart';
import '../pages/buy_credit/buy_credit_show_screen.dart';
import '../pages/buy/buy_show_screen.dart';
import '../pages/buy/buy_screen.dart';
import '../pages/sell/sell_screen.dart';
import '../providers/buy_provider.dart';
import '../pages/merchant/merchant_form_screen.dart';
import '../pages/merchant/merchant_show_screen.dart';
import '../providers/merchant_provider.dart';
import '../providers/credit_provider.dart';
import '../pages/credit/credit_show_screen.dart';
import '../pages/customer/customer_form_screen.dart';
import '../pages/customer/customer_show_screen.dart';
import '../providers/customer_provider.dart';
import '../providers/item_provider.dart';
import '../providers/stock_provider.dart';
import 'pages/sell/sell_show_screen.dart';
import 'pages/item/item_show_screen.dart';
import 'pages/category/category_form_screen.dart';
import 'pages/category/category_show_screen.dart';
import '../pages/price_track/price_track_show_screen.dart';
import '../pages/item/item_form_screen.dart';
import '../providers/category_provider.dart';
import '../providers/sale_provider.dart';
import '../providers/shop_provider.dart';
import '../pages/login_screen.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_manager.dart';
import '../providers/auth_provider.dart';
import '../providers/price_track_provider.dart';
import '../pages/stock/stock_show_screen.dart';
import '../pages/item_transfer/item_transfer_show_screen.dart';
import '../providers/item_transfer_provider.dart';
import '../pages/item_transfer/item_transfer_form_screen.dart';
import '../pages/profit/gross_profit_item_show_screen.dart';
import '../pages/shop/shop_show_screen.dart';
import '../pages/stock/all_stock_show_screen.dart';
import '../pages/sale_return_item/sale_return_item_show_screen.dart';
import '../pages/profit/sale_items_show_screen.dart';
import 'l10n/L10n.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>(
          create: (_) => ThemeManager(),
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<ShopProvider>(
          create: (_) => ShopProvider(),
        ),
        ChangeNotifierProvider<SaleProvider>(
          create: (_) => SaleProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider<ItemProvider>(
          create: (_) => ItemProvider(),
        ),
        ChangeNotifierProvider<StockProvider>(
          create: (_) => StockProvider(),
        ),
        ChangeNotifierProvider<CustomerProvider>(
          create: (_) => CustomerProvider(),
        ),
        ChangeNotifierProvider<PriceTrackProvider>(
          create: (_) => PriceTrackProvider(),
        ),
        ChangeNotifierProvider<CreditProvider>(
          create: (_) => CreditProvider(),
        ),
        ChangeNotifierProvider<MerchantProvider>(
          create: (_) => MerchantProvider(),
        ),
        ChangeNotifierProvider<BuyProvider>(
          create: (_) => BuyProvider(),
        ),
        ChangeNotifierProvider<DamageItemProvider>(
          create: (_) => DamageItemProvider(),
        ),
        ChangeNotifierProvider<ExpenseProvider>(
          create: (_) => ExpenseProvider(),
        ),
        ChangeNotifierProvider<DailyProvider>(
          create: (_) => DailyProvider(),
        ),
        ChangeNotifierProvider<YearlyProvider>(
          create: (_) => YearlyProvider(),
        ),
        ChangeNotifierProvider<MonthlyProvider>(
          create: (_) => MonthlyProvider(),
        ),
        ChangeNotifierProvider<ProfitProvider>(
          create: (_) => ProfitProvider(),
        ),
        ChangeNotifierProvider<ItemTransferProvider>(
          create: (_) => ItemTransferProvider(),
        ),
        ChangeNotifierProvider<SaleReturnItemProvider>(
          create: (_) => SaleReturnItemProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeManager themeNotifier = Provider.of<ThemeManager>(context);
    final LocaleProvider localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Code Solutions',
      theme: themeNotifier.themeData,
      initialRoute: '/',
      locale: localeProvider.locale,
      localizationsDelegates: const [
        //AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      routes: {
        '/': (ctx) => const LoginScreen(),
        '/shops': (ctx) => const ShopShowScreen(),
        '/categories': (ctx) => const CategoryShowScreen(),
        '/add_new_category': (ctx) => const CategoryFormScreen(),
        '/items': (ctx) => const ItemShowScreen(),
        '/add_new_item': (ctx) => const ItemFormScreen(),
        '/stocks': (ctx) => const StockShowScreen(),
        '/all_stocks': (ctx) => const AllStockShowScreen(),
        '/add_new_stock': (ctx) => const StockFormScreen(),
        '/customers': (ctx) => const CustomerShowScreen(),
        '/add_new_customer': (ctx) => const CustomerFormScreen(),
        '/price_tracks': (ctx) => const PriceTrackShowScreen(),
        '/sells': (ctx) => const SellShowScreen(),
        '/sell_returns': (ctx) => const SaleReturnItemShowScreen(),
        '/sell_screen': (ctx) => const SellScreen(),
        '/credits': (ctx) => const CreditShowScreen(),
        '/merchants': (ctx) => const MerchantShowScreen(),
        '/add_new_merchant': (ctx) => const MerchantFormScreen(),
        '/buy_screen': (ctx) => const BuyScreen(),
        '/buys': (ctx) => const BuyShowScreen(),
        '/buy_credits': (ctx) => const BuyCreditShowScreen(),
        '/damage_items': (ctx) => const DamageItemShowScreen(),
        '/expenses': (ctx) => const ExpenseShowScreen(),
        '/add_new_expense': (ctx) => const ExpenseFormScreen(),
        '/daily': (ctx) => const DailyShowScreen(),
        '/yearly': (ctx) => const YearlyShowScreen(),
        '/monthly': (ctx) => const MonthlyShowScreen(),
        '/profit': (ctx) => const ProfitShowScreen(),
        '/gross-profit-item': (ctx) => const GrossProfitItemShowScreen(),
        '/item_transfers': (ctx) => const ItemTransferShowScreen(),
        '/add_new_item_transfer': (ctx) => const ItemTransferFormScreen(),
        '/low_items': (ctx) => const LowStockShowScreen(),
        '/more_sale_items': (ctx) => const MoreSaleItemShowScreen(),
        '/sale_items': (ctx) => const SaleItemsShowScreen(),
        '/shop_info': (ctx) => const ShopDetailScreen(),
        '/terms_and_conditions': (ctx) => const TermsAndConditions(),
      },
    );
  }
}
