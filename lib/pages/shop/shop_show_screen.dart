import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../providers/shop_provider.dart';
import '../../../components/modules/my_app_bar.dart';
import '../../pages/sell/sell_screen.dart';
import '../../providers/stock_provider.dart';

class ShopShowScreen extends StatefulWidget {
  const ShopShowScreen({Key? key}) : super(key: key);

  @override
  State<ShopShowScreen> createState() => _ShopShowScreenState();
}

class _ShopShowScreenState extends State<ShopShowScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.shop_list,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        child: Consumer<ShopProvider>(
          builder: (BuildContext context, state, index) {
            if (state.errorMessage != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: MyButton(
                      label: state.errorMessage ?? '',
                      onPressed: state.loadShops,
                      primary: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: state.shops.length,
                itemBuilder: (context, index) {
                  return MyButton(
                    label: state.shops[index].shopName,
                    primary: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await state.showShop(state.shops[index].id);

                      if (state.errorMessage == null) {
                        await context
                            .read<StockProvider>()
                            .loadLowStocks(10, state.shop!.id);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SellScreen(),
                          ),
                        );
                      } else {
                        showAlertDialog(
                          context: context,
                          message: state.errorMessage ?? '',
                        );
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
