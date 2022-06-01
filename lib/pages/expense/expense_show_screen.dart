import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../datetime_util.dart';
import '../../models/expense_model.dart';
import '../../pages/expense/expense_detail_screen.dart';
import '../../providers/expense_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class ExpenseShowScreen extends StatefulWidget {
  const ExpenseShowScreen({Key? key}) : super(key: key);

  @override
  _ExpenseShowScreenState createState() => _ExpenseShowScreenState();
}

class _ExpenseShowScreenState extends State<ExpenseShowScreen> {
  String? startDate;
  String? endDate;
  bool _isLoading = false;
  ExpenseModel? expenseObject;
  List<ExpenseModel> _expenseList = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final ExpenseProvider expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    await expenseProvider.loadExpenses(shopProvider.shop!.id);

    _expenseList = expenseProvider.expenses;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      loadData();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int expenseTotal = 0;

    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    AppLocalizations localizations = AppLocalizations.of(context)!;

    final ExpenseProvider expenseProvider =
        Provider.of<ExpenseProvider>(context);

    for (ExpenseModel expense in expenseProvider.expenses) {
      expenseTotal += expense.amount;
    }

    List<Widget> widgetItems = [
      MyButton(
        fontSize: 14.0, //16
        verticalPadding: 12.0, //15
        horizontalPadding: 18.0, //20
        label: startDate ?? localizations.start_date,
        onPressed: () async {
          if (_expenseList.isNotEmpty) {
            DateTime? _startDate = await showDatePicker(
              context: context,
              initialDate: DateTime.parse(_expenseList.first.createdAt),
              firstDate: DateTime.parse(_expenseList.first.createdAt),
              lastDate: DateTime.parse(_expenseList.last.createdAt),
            );
            setState(() {
              startDate = _startDate.toString().substring(0, 10);
            });
          }
        },
        primary: Theme.of(context).primaryColor,
      ),
      const SizedBox(width: 10.0),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          '~',
          style: kTextStyle(size: 27.0),
        ),
      ),
      const SizedBox(width: 10.0),
      MyButton(
        fontSize: 14.0, //16
        verticalPadding: 12.0, //15
        horizontalPadding: 18.0, //20
        label: endDate ?? localizations.end_date,
        onPressed: () async {
          if (_expenseList.isNotEmpty) {
            DateTime? _endDate = await showDatePicker(
              context: context,
              initialDate: DateTime.parse(_expenseList.last.createdAt),
              firstDate: DateTime.parse(_expenseList.first.createdAt),
              lastDate: DateTime.parse(_expenseList.last.createdAt),
            );
            setState(() {
              endDate = _endDate.toString().substring(0, 10);
            });
          }
        },
        primary: Theme.of(context).primaryColor,
      ),
    ];

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.expenses,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      drawer: const MyDrawer(),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ProgressHUD(
          inAsyncCall: _isLoading,
          child: Padding(
            padding: kPadding,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widgetItems,
                ),
                const SizedBox(height: 20.0),
                MyButton(
                  fontSize: 14.0, //16
                  verticalPadding: 12.0, //15
                  horizontalPadding: 18.0, //20
                  label: localizations.check,
                  onPressed: () async {
                    await context.read<ExpenseProvider>().loadExpensesByDate(
                        shopProvider.shop!.id, startDate ?? '', endDate ?? '');
                  },
                  primary: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 10.0),
                Text(
                  '$expenseTotal Ks',
                  style: kTextStyle(size: 18.0),
                ),
                const SizedBox(height: 20.0),
                Consumer<ExpenseProvider>(
                    builder: (BuildContext context, state, index) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.expenses.length,
                      itemBuilder: (context, index) {
                        ExpenseModel expense = state.expenses[index];
                        return Card(
                          elevation: 3.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            title: Text(
                              expense.name,
                              style: kTextStyle(size: 16.0),
                            ),
                            subtitle: Text(
                              '${expense.amount} Ks',
                              style: kTextStyle(size: 16.0),
                            ),
                            trailing: Text(
                              convertDateToLocal(expense.createdAt),
                              style: kTextStyle(size: 16.0),
                            ),
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });

                              await context
                                  .read<ExpenseProvider>()
                                  .showExpense(expense.id);

                              if (state.errorMessage != null) {
                                showAlertDialog(
                                    context: context,
                                    message: state.errorMessage ?? '');
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ExpenseDetailScreen(),
                                  ),
                                );
                              }

                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 20.0),
                MyButton(
                  fontSize: 14.0, //16
                  verticalPadding: 12.0, //15
                  horizontalPadding: 18.0, //20
                  label: localizations.create_expense,
                  primary: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_new_expense');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
