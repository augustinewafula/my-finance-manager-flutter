import 'package:flutter/cupertino.dart';

import '../../screens/sign_in/sign_in_screen.dart';

Map<String, WidgetBuilder> routes() {
  return {
    '/screens.sign_in': (context) => const SignInScreen(),
  };
}
