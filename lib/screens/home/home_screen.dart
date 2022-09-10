import 'package:flutter/material.dart';

import '../../../config/size_config.dart';
import '../../services/auth.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
