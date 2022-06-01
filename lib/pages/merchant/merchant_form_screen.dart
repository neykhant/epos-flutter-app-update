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
import '../../models/merchant_model.dart';
import '../../providers/merchant_provider.dart';
import '../../providers/shop_provider.dart';

class MerchantFormScreen extends StatefulWidget {
  final MerchantModel? existedMerchant;
  const MerchantFormScreen({
    Key? key,
    this.existedMerchant,
  }) : super(key: key);

  @override
  _MerchantFormScreenState createState() => _MerchantFormScreenState();
}

class _MerchantFormScreenState extends State<MerchantFormScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  // carry data from existing customer for customer editing function
  @override
  void initState() {
    if (widget.existedMerchant != null) {
      _nameController.text = widget.existedMerchant!.name;
      _addressController.text = widget.existedMerchant!.address;
      _phoneNoController.text = widget.existedMerchant!.phoneNo;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        title: widget.existedMerchant == null
            ? localizations.create_new_merchant
            : localizations.edit_merchant,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        child: MyFormWrapper(
          formWidth: 340.0,
          formKey: _formKey,
          height: 400.0,
          children: [
            Text(
              localizations.merchant_name,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _nameController,
              decoration: kInputDecoration,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_merchant_name;
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
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_address;
                }
                return null;
              },
            ),
            Text(
              localizations.phone_no,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _phoneNoController,
              decoration: kInputDecoration,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_phone_no;
                }
                return null;
              },
            ),
            Consumer<MerchantProvider>(
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
                        if (widget.existedMerchant == null) {
                          await state.postMerchant({
                            'name': _nameController.text,
                            'address': _addressController.text,
                            'phone_no': _phoneNoController.text,
                            'shop_id': shopProvider.shop!.id,
                          });

                          if (state.errorMessage != null) {
                            showAlertDialog(
                                context: context,
                                message: state.errorMessage ?? '');
                          } else {
                            _nameController.clear();
                            _addressController.clear();
                            _phoneNoController.clear();
                          }
                        } else {
                          await state
                              .updateMerchant(widget.existedMerchant!.id, {
                            'name': _nameController.text,
                            'address': _addressController.text,
                            'phone_no': _phoneNoController.text,
                            'shop_id': shopProvider.shop!.id,
                          });

                          if (state.errorMessage != null) {
                            showAlertDialog(
                                context: context,
                                message: state.errorMessage ?? '');
                          } else {
                            Navigator.pop(context);
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
