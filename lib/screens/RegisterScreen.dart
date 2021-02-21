import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:login_application_1/networking/networkhelper.dart';
import 'package:login_application_1/styles/mywidgets.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController email = TextEditingController(),
      password = TextEditingController();
  NetworkHelper networkHelper = NetworkHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Image(image: AssetImage('images/ic_register.png'),height: 140,width: 140,),
                ),
                Text(
                  'Register',
                  style: TextStyle(fontSize: 30.0),
                ),
                InputText(
                  label: 'Email',
                  hint: 'Enter Email',
                  inputControl: email,
                ),
                InputText(
                  label: 'Password',
                  hint: 'Enter Password',
                  inputControl: password,
                ),
                MyLoginTypeButton(
                  label: 'Register',
                  onPressed: () async {
                    Response response = await networkHelper.register(
                        email: email.text, password: password.text);
                    print(response.body);
                    if (response.statusCode == 200) {
                      if (jsonDecode(response.body)['token'] != null) {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      } else {
                        Toast.show(jsonDecode(response.body)['error'], context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    } else {
                      Toast.show(jsonDecode(response.body)['error'], context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
