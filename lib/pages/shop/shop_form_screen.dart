import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../components/elements/my_alert_dialog.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/shop_model.dart';
import '../../providers/shop_provider.dart';
import '../../components/elements/my_form_wrapper.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/my_text_form_field.dart';
import '../../components/modules/my_app_bar.dart';
import '../../utility_methods.dart';

class ShopFormScreen extends StatefulWidget {
  const ShopFormScreen({Key? key}) : super(key: key);

  @override
  _ShopFormScreenState createState() => _ShopFormScreenState();
}

class _ShopFormScreenState extends State<ShopFormScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _phoneNoOneController = TextEditingController();
  final TextEditingController _phoneNoTwoController = TextEditingController();
  final TextEditingController _employeesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    ShopModel? shop = Provider.of<ShopProvider>(context, listen: false).shop;
    _shopNameController.text = shop!.shopName;
    _phoneNoOneController.text = shop.phoneNoOne!;
    _phoneNoTwoController.text = shop.phoneNoTwo!;
    _employeesController.text = shop.employees.toString();
    _addressController.text = shop.address;

    super.initState();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _phoneNoOneController.dispose();
    _phoneNoTwoController.dispose();
    _employeesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.edit_shop,
        fontSize: 18.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        child: MyFormWrapper(
          formKey: _formKey,
          formWidth: 340.0,
          height: 835.0,
          children: [
            Text(
              localizations.shop_name,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _shopNameController,
              decoration: kInputDecoration,
              keyboardType: TextInputType.text,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_shop_name;
                }
                return null;
              },
            ),
            Text(
              '${localizations.phone_no} - 1',
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _phoneNoOneController,
              decoration: kInputDecoration,
              keyboardType: TextInputType.phone,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_phone_no;
                }
                return null;
              },
            ),
            Text(
              '${localizations.phone_no} - 2',
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _phoneNoTwoController,
              decoration: kInputDecoration,
              keyboardType: TextInputType.phone,
            ),
            Text(
              localizations.employees,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _employeesController,
              decoration: kInputDecoration,
              keyboardType: TextInputType.number,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_employees;
                }
                return null;
              },
            ),
            Text(
              localizations.address,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _addressController,
              decoration: kInputDecoration,
              keyboardType: TextInputType.text,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_address;
                }
                return null;
              },
            ),
            Consumer<ShopProvider>(
                builder: (BuildContext context, state, index) {
              return Center(
                child: MyButton(
                  fontSize: 16.0,
                  label: localizations.save,
                  verticalPadding: 15.0,
                  horizontalPadding: 20.0,
                  primary: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      await context
                          .read<ShopProvider>()
                          .updateShop(state.shop!.id, {
                        "name": _shopNameController.text,
                        "phone_no_one": _phoneNoOneController.text,
                        "phone_no_two": _phoneNoTwoController.text,
                        "address": _addressController.text,
                        "employees": _employeesController.text,
                      });

                      if (state.errorMessage != null) {
                        showAlertDialog(
                            context: context,
                            message: localizations.alert_error);
                      } else {
                        Navigator.pop(context);
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
