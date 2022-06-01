import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shop_provider.dart';
import '../elements/profile_component_phone.dart';
import '../../providers/locale_provider.dart';
import '../../utility_methods.dart';
import '../../l10n/L10n.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final double fontSize;

  const MyAppBar({
    Key? key,
    required this.title,
    required this.backgroundColor,
    this.fontSize = 23.0,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    Text _title(String val) {
      switch (val) {
        case 'en':
          return const Text(
            'EN',
            style: TextStyle(fontSize: 16.0),
          );
        case 'my':
          return const Text(
            'MM',
            style: TextStyle(fontSize: 16.0),
          );

        default:
          return const Text(
            'EN',
            style: TextStyle(fontSize: 16.0),
          );
      }
    }

    return AppBar(
      backgroundColor: backgroundColor,
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        title,
        style: kTextStyle(size: fontSize).copyWith(
          color: Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
      elevation: 0,
      actions: [
        Consumer<LocaleProvider>(
          builder: (context, provider, snapshot) {
            Locale lang = provider.locale ?? Localizations.localeOf(context);
            return Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Theme.of(context).primaryColor,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  iconEnabledColor:
                      Theme.of(context).textTheme.bodyText1?.color,
                  iconDisabledColor:
                      Theme.of(context).textTheme.bodyText1?.color,
                  value: lang,
                  onChanged: (Locale? val) {
                    provider.setLocale(val!);
                  },
                  style: kTextStyle().copyWith(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
                  items: L10n.all
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: _title(e.languageCode),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              showPopupMenu(
                context: context,
                shopName: Provider.of<ShopProvider>(context, listen: false)
                    .shop!
                    .shopName,
                ownerName: Provider.of<AuthProvider>(context, listen: false)
                    .loginModel!
                    .username,
              );
            },
          ),
        ),
      ],
    );
  }
}
