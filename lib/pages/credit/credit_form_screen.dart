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
import '../../pages/credit/credit_show_screen.dart';
import '../../providers/credit_provider.dart';

class CreditFormScreen extends StatefulWidget {
  final int saleRecordId;
  const CreditFormScreen({
    Key? key,
    required this.saleRecordId,
  }) : super(key: key);

  @override
  _CreditFormScreenState createState() => _CreditFormScreenState();
}

class _CreditFormScreenState extends State<CreditFormScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.create_credit,
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
              localizations.amount,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _amountController,
              decoration: kInputDecoration,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_amount;
                }
                return null;
              },
            ),
            Consumer<CreditProvider>(
              builder: (BuildContext context, state, index) {
                // print(state);
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
                        await state.postCredit({
                          'amount': _amountController.text,
                          'sale_record_id': widget.saleRecordId,
                        });

                        if (state.errorMessage != null) {
                          showAlertDialog(
                              context: context,
                              message: state.errorMessage ?? '');
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreditShowScreen(),
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
