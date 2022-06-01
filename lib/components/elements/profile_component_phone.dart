import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utility_methods.dart';
import 'theme_button.dart';
import '../../theme_values.dart';

void showPopupMenu(
    {context, required String shopName, required String ownerName}) async {
  await showMenu(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    elevation: 0,
    color: Theme.of(context).primaryColor,
    context: context,
    position: const RelativeRect.fromLTRB(100, 95, 0, 0),
    items: <PopupMenuEntry<dynamic>>[
      PopupMenuItem(
        enabled: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ThemeButton(
              theme: AppTheme.ImperialBlue,
              color: Color.fromRGBO(128, 183, 222, 1),
            ),
            SizedBox(width: 10.0),
            ThemeButton(
              theme: AppTheme.GreenBlue,
              color: Color.fromRGBO(87, 191, 196, 1),
            ),
            SizedBox(width: 10.0),
            ThemeButton(
              theme: AppTheme.Yellow,
              color: Color.fromRGBO(248, 194, 0, 1),
            ),
            SizedBox(width: 10.0),
            ThemeButton(
              theme: AppTheme.Black,
              color: Color.fromRGBO(63, 63, 63, 1),
            ),
            SizedBox(width: 10.0),
            ThemeButton(
              theme: AppTheme.RCS,
              color: Color.fromRGBO(83, 49, 37, 1),
            ),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        enabled: false,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Text(
                '${AppLocalizations.of(context)!.shop_name} - $shopName',
                style: kTextStyle(size: 16.0).copyWith(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                '${AppLocalizations.of(context)!.owner_name} - $ownerName',
                style: kTextStyle(size: 16.0).copyWith(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        enabled: false,
        child: Center(
          child: TextButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 15.0,
              ),
              child: Text(
                'Logout',
                style: kTextStyle(size: 16.0).copyWith(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
            ),
            style: TextButton.styleFrom(
              side: const BorderSide(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ),
      ),
    ],
  );
}
