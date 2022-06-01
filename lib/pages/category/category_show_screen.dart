import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../components/modules/my_app_bar.dart';
import '../../../components/modules/my_drawer_phone.dart';
import '../../components/elements/my_button.dart';
import '../../components/elements/progress_hud.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../utility_methods.dart';
import 'category_form_screen.dart';

class CategoryShowScreen extends StatefulWidget {
  const CategoryShowScreen({Key? key}) : super(key: key);

  @override
  _CategoryShowScreenState createState() => _CategoryShowScreenState();
}

class _CategoryShowScreenState extends State<CategoryShowScreen> {
  bool _isLoading = false;
  CategoryModel? categoryObject;
  List<CategoryModel> _categoryList = [];
  List<String> categoryNames = [];

  bool _isInit = false;

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.loadCategories();

    _categoryList = categoryProvider.categories;

    categoryNames.clear();
    for (var i = 0; i < _categoryList.length; i++) {
      categoryNames.add(_categoryList[i].name);
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
    List<CategoryModel> _usedCategoryList = categoryObject == null
        ? _categoryList
        : _categoryList.where((e) => e.name == categoryObject!.name).toList();

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.categories,
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
                  hint: localizations.select_category,
                  mode: Mode.MENU,
                  items: categoryNames,
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: (String? data) {
                    if (data != null) {
                      for (var i = 0; i < _categoryList.length; i++) {
                        if (_categoryList[i].name == data) {
                          setState(() {
                            categoryObject = _categoryList[i];
                          });
                        }
                      }
                    } else {
                      setState(() {
                        categoryObject = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usedCategoryList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3.0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          title: Text(
                            _usedCategoryList[index].name,
                            style: kTextStyle(size: 16.0),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryFormScreen(
                                    existedCategory: _usedCategoryList[index]),
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
                  verticalPadding: 12.0, //15
                  horizontalPadding: 20.0,
                  fontSize: 14.0, //16
                  label: localizations.create_category,
                  primary: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_new_category');
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
