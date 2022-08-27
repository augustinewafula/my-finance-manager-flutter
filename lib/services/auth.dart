import 'package:shared_preferences/shared_preferences.dart';

import 'rest_api_service.dart';

class Auth {
  static String authToken = '';
  static String email = '';

  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString('authToken')!;
    email = sharedPreferences.getString('email')!;
    if (authToken.isEmpty) {
      sharedPreferences.setString('authToken', "");
    }
    if (email.isEmpty) {
      sharedPreferences.setString('email', "");
    }
    RestApiService().init();
  }
}

String getAuthToken() {
  if (Auth.authToken.isEmpty) {
    return '';
  }
  return Auth.authToken;
}

String getEmail() {
  return Auth.email;
}

Future<void> setAuthToken(String token) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString('authToken', token);
}

Future<void> setEmail(String email) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString('email', email);
}

bool isAuthenticated() {
  return getAuthToken().isNotEmpty ? true : false;
}

Future<bool> clearAuthSharedPreferences() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString('authToken', "");
  sharedPreferences.setString('email', "");
  return true;
}
