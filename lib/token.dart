import 'package:shared_preferences/shared_preferences.dart';

const tokenName = 'SYW-Secret-Token';

class Token {
  static saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenName, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? prefsToken = prefs.getString(tokenName);

    return prefsToken;
  }

  static deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenName, '');
  }
}
