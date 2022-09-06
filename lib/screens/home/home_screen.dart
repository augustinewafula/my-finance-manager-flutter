import 'package:flutter/material.dart';

import '../../../config/size_config.dart';
import '../../services/auth.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const validAddresses = ['MPESA', '+254720810670'];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Auth().init();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
        ),
        centerTitle: false,
      ),
      body: const Body(),
    );
  }
}
