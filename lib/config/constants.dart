import 'dart:ui';

const kPrimaryColor = Color.fromRGBO(143, 148, 251, 1);
const kPrimaryLightColor = Color.fromRGBO(143, 148, 251, .6);

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kConfirmPassError = "Please re-type your password";
const String kFullNameNullError = "Please Enter your full name";
