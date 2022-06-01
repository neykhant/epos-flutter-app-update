import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/elements/my_button.dart';
import '../../../components/elements/my_form_wrapper.dart';
import '../../../components/elements/my_text_form_field.dart';
import '../../../components/elements/progress_hud.dart';
import '../../../components/modules/my_app_bar.dart';
import '../../../utility_methods.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../pages/sell/sell_show_screen.dart';
import '../../providers/sale_return_item_provider.dart';
import '../../providers/shop_provider.dart';

class SaleReturnItemFormScreen extends StatefulWidget {
  final int? singleSaleId;
  const SaleReturnItemFormScreen({
    Key? key,
    required this.singleSaleId,
  }) : super(key: key);

  @override
  _SaleReturnItemFormScreenState createState() =>
      _SaleReturnItemFormScreenState();
}

class _SaleReturnItemFormScreenState extends State<SaleReturnItemFormScreen> {
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
        title: localizations.create_sale_return,
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
            Consumer<SaleReturnItemProvider>(
              builder: (BuildContext context, state, index) {
                return Center(
                  child: MyButton(
                    label: localizations.save,
                    fontSize: 14.0, //16
                    verticalPadding: 12.0, //15
                    horizontalPadding: 18.0, //20
                    primary: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        await state.postSaleReturnItem({
                          'quantity': _quantityController.text,
                          'single_sale_id': widget.singleSaleId,
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
                              builder: (context) => const SellShowScreen(),
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
