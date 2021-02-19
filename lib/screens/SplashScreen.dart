import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:login_application_1/model/user.dart';
import 'package:login_application_1/screens/HomeScreen.dart';
import 'package:login_application_1/screens/LoginScreen.dart';
import 'package:login_application_1/storage/sharedprefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  void checkUserExistence(BuildContext context) async {
    Future.delayed(Duration(seconds: 3), () async {
      // 5s over, navigate to a new page
      SharedPreferences pref = await AppSharedPrefs.getPref();

      if (pref.containsKey('logged_in')) {
        if (await AppSharedPrefs.isUserLoggedIn()) {
          User user = new User();
          user.setToken(await AppSharedPrefs.getAuthtoken());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeScreen(user)));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkUserExistence(context);
    return Scaffold(
      body: Center(
        child: SpinKitRotatingCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
