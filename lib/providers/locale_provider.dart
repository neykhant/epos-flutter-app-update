import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/L10n.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  final String _kLocalPreference = 'LocalPreference';

  LocaleProvider() {
    _loadLocale();
  }

  _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String preferredLocale = prefs.getString(_kLocalPreference) ?? 'en';
    _locale = Locale(preferredLocale);
    notifyListeners();
  }

  setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kLocalPreference, locale.languageCode);
    _locale = locale;
    notifyListeners();
  }
}
