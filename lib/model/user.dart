import 'dart:convert';

import 'package:http/http.dart';

class User {
  String token;

  void setToken(String token) {
    this.token = token;
  }

  String getToken() {
    return token;
  }

  User fromJson(Response response) {
    dynamic data = jsonDecode(response.body);
    User user = new User();
    user.setToken(data['token']);
    return user;
  }
}
