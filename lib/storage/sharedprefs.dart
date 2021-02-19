import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefs
{
  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged_in');
  }

  static Future<SharedPreferences> getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future<String> getAuthtoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('authtoken');
  }
}
