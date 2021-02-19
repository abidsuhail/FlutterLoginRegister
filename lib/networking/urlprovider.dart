class UrlProvider {
  static String _domain = 'https://reqres.in/';

  static String getLoginUrl() => '${_domain}api/login';
  static String getRegisterUrl() => '${_domain}api/register';
}
