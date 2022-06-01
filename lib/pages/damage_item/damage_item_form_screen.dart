import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../pages/buy/buy_show_screen.dart';
import '../../providers/damage_item_provider.dart';
import '../../providers/shop_provider.dart';

import '../../../components/elements/my_form_wrapper.dart';
import '../../../components/elements/my_button.dart';
import '../../../components/elements/my_text_form_field.dart';
import '../../../components/modules/my_app_bar.dart';
import '../../../components/elements/progress_hud.dart';
import '../../components/elements/my_alert_dialog.dart';

import '../../../utility_methods.dart';

class DamageItemFormScreen extends StatefulWidget {
  final int? singleBuyId;
  const DamageItemFormScreen({
    Key? key,
    required this.singleBuyId,
  }) : super(key: key);

  @override
  _DamageItemFormScreenState createState() => _DamageItemFormScreenState();
}

class _DamageItemFormScreenState extends State<DamageItemFormScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.create_damage,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        child: MyFormWrapper(
          formWidth: 340.0,
          formKey: _formKey,
          height: 200.0,
          children: [
            Text(
              localizations.quantity,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _quantityController,
              decoration: kInputDecoration,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_quantity;
                }
                return null;
              },
            ),
            Consumer<DamageItemProvider>(
              builder: (BuildContext context, state, index) {
                return Center(
                  child: MyButton(
                    label: localizations.save,
                    fontSize: 16.0,
                    verticalPadding: 15.0,
                    horizontalPadding: 20.0,
                    primary: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        await state.postDamageItem({
                          'quantity': _quantityController.text,
                          'single_buy_id': widget.singleBuyId,
                          'shop_id': shopProvider.shop!.id,
                        });

                        if (state.errorMessage != null) {
                          showAlertDialog(
                              context: context,
                              message: state.errorMessage ?? '');
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BuyShowScreen(),
                            ),
                          );
                        }
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
