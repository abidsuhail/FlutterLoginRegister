import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:login_application_1/model/user.dart';
import 'package:login_application_1/networking/networkhelper.dart';
import 'package:login_application_1/screens/HomeScreen.dart';
import 'package:login_application_1/screens/RegisterScreen.dart';
import 'package:login_application_1/styles/mywidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  NetworkHelper networkHelper = NetworkHelper.getInstance();
  String username, password;
  bool show = false;
  bool showProgress = false;
  TextEditingController
      txtUsernameCtrl = TextEditingController(),
      txtPwdCtrl = TextEditingController();

  _LoginScreenState() {
    txtUsernameCtrl.text = 'eve.holt@reqres.in';
    txtPwdCtrl.text = 'cityslicka';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(accentColor: Colors.orange),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Opacity(
                    opacity: showProgress ? 1 : 0,
                    child: CircularProgressIndicator()),
                Text(
                  'Welcome',
                  style: TextStyle(fontSize: 35.0),
                ),
                Text(
                  'Login',
                  style: TextStyle(fontSize: 30.0),
                ),
                InputText(
                  inputControl: txtUsernameCtrl,
                  hint: 'Enter Email',
                  label: "Email",
                ),
                InputText(
                  inputControl: txtPwdCtrl,
                  hint: 'Enter Password',
                  label: 'Password',
                ),
                MyLoginTypeButton(
                  label: 'Login',
                  onPressed: () async {
                    try {
                      setState(() {
                        showProgress = true;
                      });
                      Response response = await networkHelper.login(
                          username: txtUsernameCtrl.text,
                          password: txtPwdCtrl.text);
                      if (response.statusCode == 200)
                      {
                        saveDetailsToLocal(response);
                        gotoHomeScreen(response);
                        Toast.show("Success", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      } else {
                        Toast.show(jsonDecode(response.body)['error'], context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      }
                      setState(() {
                        if (response.statusCode == 200) {
                          show = true;
                        } else {
                          show = false;
                        }
                        showProgress = false;
                      });
                    } catch (e) {
                      setState(() {
                        showProgress = false;
                      });
                      Toast.show('Username/Password is null', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => {
                      //start reg. screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ))
                    },
                    child: Text(
                      'Register?',
                      style: TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void gotoHomeScreen(Response response) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen(User().fromJson(response))),
    );
  }

  void saveDetailsToLocal(Response response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged_in', true);
    prefs.setString('authtoken', User().fromJson(response).getToken());
  }
}
