import 'package:http/http.dart';
import 'package:login_application_1/networking/urlprovider.dart';

class NetworkHelper {
  static NetworkHelper instance;
  static NetworkHelper getInstance() {
    if (instance == null) {
      instance = NetworkHelper();
    }
    return instance;
  }

  Future<Response> login({String username, String password}) async {
    var response = await post(UrlProvider.getLoginUrl(),
        body: {'email': username, 'password': password});

    return response;
  }

  Future<Response> register({String email, String password}) async {
    var response = await post(UrlProvider.getRegisterUrl(),
        body: {'email': email, 'password': password});

    return response;
  }
  Future<Response> getAllPosts() async {
    var response = await get(UrlProvider.getAllPosts());
    return response;
  }
}
