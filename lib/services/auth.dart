import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String authToken = sharedPreferences.getString('authToken')!;
    String email = sharedPreferences.getString('email')!;
    if (authToken.isEmpty) {
      sharedPreferences.setString('authToken', "");
    }
    if (email.isEmpty) {
      sharedPreferences.setString('email', "");
    }
  }
}

Future<String> getAuthToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String authToken = sharedPreferences.getString('authToken')!;
  if (authToken.isEmpty) {
    return '';
  }

  return authToken;
}

Future<String> getEmail() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String email = sharedPreferences.getString('email')!;

  return email;
}

Future<void> setAuthToken(String token) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString('authToken', token);
}

Future<void> setEmail(String email) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString('email', email);
}

Future<bool> isAuthenticated() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String authToken = sharedPreferences.getString('authToken')!;

  return authToken.isNotEmpty ? true : false;
}

Future<bool> clearAuthSharedPreferences() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString('authToken', "");
  sharedPreferences.setString('email', "");
  return true;
}
