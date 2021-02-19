class UrlProvider {
  static String _domain = 'https://reqres.in/';
  static String _domain2 = 'https://jsonplaceholder.typicode.com/';
  static String getLoginUrl() => '${_domain}api/login';
  static String getRegisterUrl() => '${_domain}api/register';
  static String getAllPosts()=>'${_domain2}posts';
}
