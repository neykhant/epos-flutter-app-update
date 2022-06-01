import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../components/elements/my_button.dart';
import '../../components/modules/my_app_bar.dart';
import '../../components/modules/my_drawer_phone.dart';
import '../../pages/shop/shop_form_screen.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({Key? key}) : super(key: key);

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: MyAppBar(
          title: localizations.shop_info,
          backgroundColor: Theme.of(context).primaryColor,
          fontSize: 18.0,
        ),
        drawer: const MyDrawer(),
        body: Consumer<ShopProvider>(
          builder: (BuildContext context, state, index) {
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 40.0),
                  width: 340,
                  child: Card(
                    elevation: 0,
                    shape: kRoundedRectangleBorder,
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 20.0),
                          child: Text(
                            localizations.shop_info,
                            style: kTextStyle(size: 21).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ShopInfoText(
                          text: localizations.shop_name,
                          fontWeight: FontWeight.bold,
                        ),
                        ShopInfoText(
                          text: state.shop?.shopName ?? '',
                        ),
                        const SizedBox(height: 15.0),
                        ShopInfoText(
                          text: '${localizations.phone_no}-1',
                          fontWeight: FontWeight.bold,
                        ),
                        ShopInfoText(
                          text: state.shop?.phoneNoOne ?? '',
                        ),
                        const SizedBox(height: 15.0),
                        ShopInfoText(
                          text: '${localizations.phone_no}-2',
                          fontWeight: FontWeight.bold,
                        ),
                        ShopInfoText(
                          text: state.shop?.phoneNoTwo ?? '',
                        ),
                        const SizedBox(height: 15.0),
                        ShopInfoText(
                          text: localizations.employees,
                          fontWeight: FontWeight.bold,
                        ),
                        ShopInfoText(
                          text: state.shop?.employees.toString() ?? '',
                        ),
                        const SizedBox(height: 15.0),
                        ShopInfoText(
                          text: localizations.address,
                          fontWeight: FontWeight.bold,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ShopInfoText(
                            text: state.shop?.address ?? '',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 10.0),
                          child: MyButton(
                            fontSize: 14.0, //16
                            verticalPadding: 12.0, //15
                            horizontalPadding: 18.0, //20
                            label: localizations.edit_shop,
                            primary: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ShopFormScreen(),
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
          },
        ));
  }
}

class ShopInfoText extends StatelessWidget {
  const ShopInfoText({
    Key? key,
    required this.text,
    this.fontWeight,
  }) : super(key: key);

  final String text;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
      child: Text(
        text,
        style: kTextStyle(size: 16.0).copyWith(
          fontWeight: fontWeight,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
