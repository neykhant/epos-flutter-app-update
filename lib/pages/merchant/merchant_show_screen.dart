import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/merchant_model.dart';
import '../../pages/merchant/merchant_form_screen.dart';
import '../../providers/merchant_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';

class MerchantShowScreen extends StatefulWidget {
  const MerchantShowScreen({Key? key}) : super(key: key);

  @override
  _MerchantShowScreenState createState() => _MerchantShowScreenState();
}

class _MerchantShowScreenState extends State<MerchantShowScreen> {
  bool _isLoading = false;
  MerchantModel? merchantObject;
  List<MerchantModel> _merchantList = [];
  List<String> merchantNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);

    final MerchantProvider merchantProvider =
        Provider.of<MerchantProvider>(context, listen: false);
    await merchantProvider.loadMerchants(shopProvider.shop!.id);

    _merchantList = merchantProvider.merchants;

    for (var i = 0; i < _merchantList.length; i++) {
      merchantNames.add(_merchantList[i].name);
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
    List<MerchantModel> _usedMerchantList = merchantObject == null
        ? _merchantList
        : _merchantList.where((e) => e.name == merchantObject!.name).toList();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.merchants,
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
                  hint: localizations.select_merchants,
                  mode: Mode.MENU,
                  items: merchantNames,
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _merchantList.length; i++) {
                        if (_merchantList[i].name == data) {
                          setState(() {
                            merchantObject = _merchantList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        merchantObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedMerchantList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3.0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          title: Text(
                            _usedMerchantList[index].name,
                            style: kTextStyle(size: 16.0),
                          ),
                          subtitle: Text(
                            _usedMerchantList[index].phoneNo,
                            style: kTextStyle(size: 16.0),
                          ),
                          trailing: Text(
                            _usedMerchantList[index].address,
                            style: kTextStyle(size: 16.0),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MerchantFormScreen(
                                    existedMerchant: _usedMerchantList[index]),
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
                  label: localizations.create_new_merchant,
                  primary: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_new_merchant');
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
