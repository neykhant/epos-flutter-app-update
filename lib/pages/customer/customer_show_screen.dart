import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/customer_model.dart';
import '../../pages/customer/customer_form_screen.dart';
import '../../providers/customer_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class CustomerShowScreen extends StatefulWidget {
  const CustomerShowScreen({Key? key}) : super(key: key);

  @override
  _CustomerShowScreenState createState() => _CustomerShowScreenState();
}

class _CustomerShowScreenState extends State<CustomerShowScreen> {
  bool _isLoading = false;
  CustomerModel? customerObject;
  List<CustomerModel> _customerList = [];
  List<String> customerNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final CustomerProvider customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    await customerProvider.loadCustomers(shopProvider.shop!.id);

    _customerList = customerProvider.customers;

    for (var i = 0; i < _customerList.length; i++) {
      customerNames.add(_customerList[i].name);
    }

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
    List<CustomerModel> _usedCustomerList = customerObject == null
        ? _customerList
        : _customerList.where((e) => e.name == customerObject!.name).toList();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.customers,
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
                DropdownSearch<String>(
                  // ignore: deprecated_member_use
                  hint: localizations.select_customer,
                  mode: Mode.MENU,
                  items: customerNames,
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _customerList.length; i++) {
                        if (_customerList[i].name == data) {
                          setState(() {
                            customerObject = _customerList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        customerObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedCustomerList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3.0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          title: Text(
                            _usedCustomerList[index].name,
                            style: kTextStyle(size: 16.0),
                          ),
                          subtitle: Text(
                            _usedCustomerList[index].phoneNo,
                            style: kTextStyle(size: 16.0),
                          ),
                          trailing: Text(
                            _usedCustomerList[index].address,
                            style: kTextStyle(size: 16.0),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerFormScreen(
                                    existedCustomer: _usedCustomerList[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                MyButton(
                  fontSize: 14.0, //16
                  verticalPadding: 12.0, //15
                  horizontalPadding: 18.0, //20
                  label: localizations.create_new_customer,
                  primary: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_new_customer');
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
