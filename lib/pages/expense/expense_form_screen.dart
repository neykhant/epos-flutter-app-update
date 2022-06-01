import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/my_form_wrapper.dart';
import '../../components/elements/my_text_form_field.dart';
import '../../components/elements/progress_hud.dart';
import '../../components/modules/my_app_bar.dart';
import '../../models/expense_model.dart';
import '../../providers/expense_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class ExpenseFormScreen extends StatefulWidget {
  final ExpenseModel? existedExpense;
  const ExpenseFormScreen({
    Key? key,
    this.existedExpense,
  }) : super(key: key);

  @override
  _ExpenseFormScreenState createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // carry data from existing item for item editing function
  @override
  void initState() {
    if (widget.existedExpense != null) {
      _nameController.text = widget.existedExpense!.name;
      _amountController.text = widget.existedExpense!.amount.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        title: widget.existedExpense == null
            ? localizations.create_expense
            : localizations.edit_expense,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        child: MyFormWrapper(
          formWidth: 340.0,
          formKey: _formKey,
          height: 300.0,
          children: [
            Text(
              localizations.expense_name,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _nameController,
              decoration: kInputDecoration,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_expense;
                }
                return null;
              },
            ),
            Text(
              localizations.amount,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _amountController,
              decoration: kInputDecoration,
              keyboardType: TextInputType.number,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_amount;
                }
                if (int.tryParse(value.trim()) == null) {
                  return 'Enter number';
                }
                return null;
              },
            ),
            Consumer<ExpenseProvider>(
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
                        if (widget.existedExpense == null) {
                          Map<String, dynamic> expense = {
                            'name': _nameController.text,
                            'amount': int.parse(_amountController.text),
                            'shop_id': shopProvider.shop!.id,
                          };

                          await context
                              .read<ExpenseProvider>()
                              .postExpense(expense);

                          if (state.errorMessage != null) {
                            showAlertDialog(
                                context: context,
                                message: state.errorMessage ?? '');
                          } else {
                            _nameController.clear();
                            _amountController.clear();
                          }
                        } else {
                          Map<String, dynamic> expense = {
                            'name': _nameController.text,
                            'amount': int.parse(_amountController.text),
                            'shop_id': shopProvider.shop!.id,
                          };

                          await context.read<ExpenseProvider>().updateExpense(
                              widget.existedExpense!.id, expense);

                          if (state.errorMessage != null) {
                            showAlertDialog(
                                context: context,
                                message: state.errorMessage ?? '');
                          } else {
                            Navigator.of(context).pushNamed('/expenses');
                          }
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
