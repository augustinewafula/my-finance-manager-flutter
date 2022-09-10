import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';

import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../config/constants.dart';
import '../../../services/auth.dart';
import '../../../services/network_status.dart';
import '../../../services/rest_api_service.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  late String email, password;

  bool remember = false;

  List<String> errors = [];

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      _formKey.currentState?.save();
      bool isInternetAvailable = await NetworkStatus().isInternetAvailable();
      if (!isInternetAvailable) {
        EasyLoading.showError('No internet connection');
        return;
      }

      errors = [];
      Response response = await login(email, password);
      var message;
      try {
        message = json.decode(response.body);
      } on Exception {
        errors.add("Server error, please retry later.");
        EasyLoading.dismiss();

        return;
      }
      if (response.statusCode == 200) {
        setAuthToken(message['token']);
        setEmail(email);
        Navigator.pushNamedAndRemoveUntil(
            context, "/screens.home", (route) => false);
      } else if (response.statusCode == 422) {
        try {
          var responseErrors = message['errors'];
          setState(() {
            responseErrors.forEach((name, description) {
              errors.add(description[0]);
            });
          });
        } catch (e) {
          setState(() {
            errors.add("Something went wrong.");
          });
        }
      } else {
        setState(() {
          errors.add("Server error.");
        });
      }
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 400,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 30,
                  width: 80,
                  height: 200,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'))),
                  ),
                ),
                Positioned(
                  left: 140,
                  width: 80,
                  height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'))),
                  ),
                ),
                Positioned(
                  right: 40,
                  top: 40,
                  width: 80,
                  height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'))),
                  ),
                ),
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade100))),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (newValue) => email = newValue!,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(error: kEmailNullError);
                              } else if (emailValidatorRegExp.hasMatch(value)) {
                                removeError(error: kInvalidEmailError);
                              }
                              return;
                            },
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                addError(error: kEmailNullError);
                                return "";
                              } else if (!emailValidatorRegExp
                                  .hasMatch(value!)) {
                                addError(error: kInvalidEmailError);
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            onSaved: (newValue) => password = newValue!,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(error: kPassNullError);
                              }
                              return;
                            },
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                addError(error: kPassNullError);
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FormError(key: UniqueKey(), errors: errors),
                  DefaultButton(
                    text: "Login",
                    onPressed: submitForm,
                    key: UniqueKey(),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
