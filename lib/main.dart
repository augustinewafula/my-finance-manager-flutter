import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_finance_manager/config/routes/routes.dart';

Future main() async {
  runApp(const MyApp());
  await dotenv.load();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Finance Manager',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      routes: routes(),
      initialRoute: '/screens.home',
      builder: EasyLoading.init(),
    );
  }
}
