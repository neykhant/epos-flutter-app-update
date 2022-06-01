import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/my_confirm_dialog.dart';
import '../../components/modules/my_app_bar.dart';
import '../../models/expense_model.dart';
import '../../pages/expense/expense_form_screen.dart';
import '../../pages/expense/expense_show_screen.dart';
import '../../providers/expense_provider.dart';
import '../../utility_methods.dart';

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Consumer<ExpenseProvider>(
      builder: (BuildContext context, state, child) {
        ExpenseModel expense = state.expense!;
        return Scaffold(
          appBar: MyAppBar(
            title: expense.name,
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
              height: 260,
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
                        localizations.expense_name,
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
                          expense.name,
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
                        localizations.amount,
                        style: kTextStyle(size: 16.0),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '=',
                        style: kTextStyle(),
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        '${expense.amount} Ks',
                        style: kTextStyle(size: 16.0),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: MyButton(
                          label: localizations.edit_expense,
                          fontSize: 14.0, //16
                          verticalPadding: 12.0, //15
                          horizontalPadding: 18.0, //20
                          primary: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExpenseFormScreen(existedExpense: expense),
                              ),
                            );
                          },
                        ),
                      ),
                      Consumer<ExpenseProvider>(
                        builder: (BuildContext context, state, index) {
                          return IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showConfirmDialog(
                                context: context,
                                message: localizations.sure_delete,
                                onPressed: () async {
                                  Navigator.pop(context);

                                  await context
                                      .read<ExpenseProvider>()
                                      .deleteExpense(expense.id);
                                  if (state.errorMessage == null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ExpenseShowScreen(),
                                      ),
                                    );
                                  } else {
                                    showAlertDialog(
                                        context: context,
                                        message: state.errorMessage ?? '');
                                  }
                                },
                              );
                            },
                          );
                        },
                      )
                    ],
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
