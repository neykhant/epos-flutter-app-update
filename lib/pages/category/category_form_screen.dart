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
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';

class CategoryFormScreen extends StatefulWidget {
  final CategoryModel? existedCategory;
  const CategoryFormScreen({
    Key? key,
    this.existedCategory,
  }) : super(key: key);

  @override
  _CategoryFormScreenState createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  // carry data from existing customer for customer editing function
  @override
  void initState() {
    if (widget.existedCategory != null) {
      _nameController.text = widget.existedCategory!.name;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: widget.existedCategory == null
            ? localizations.create_category
            : localizations.edit_category,
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
              localizations.category_name,
              style: kTextStyle(size: 16.0),
            ),
            MyTextFormField(
              controller: _nameController,
              decoration: kInputDecoration,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return localizations.enter_item_category;
                }
                return null;
              },
            ),
            Consumer<CategoryProvider>(
              builder: (BuildContext context, state, index) {
                return Center(
                  child: MyButton(
                    label: localizations.save,
                    fontSize: 14.0, //16
                    verticalPadding: 12.0, //15
                    horizontalPadding: 20.0,
                    primary: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        if (widget.existedCategory == null) {
                          await state.postCategory({
                            'name': _nameController.text,
                          });

                          if (state.errorMessage != null) {
                            showAlertDialog(
                                context: context,
                                message: state.errorMessage ?? '');
                          } else {
                            _nameController.clear();
                          }
                        } else {
                          await state
                              .updateCategory(widget.existedCategory!.id, {
                            'name': _nameController.text,
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
