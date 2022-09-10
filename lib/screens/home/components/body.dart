import 'package:flutter/material.dart';

import '../../../config/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: SizeConfig.screenHeight,
        child: Column(children: <Widget>[
          SizedBox(
            height: SizeConfig.screenHeight * 0.1,
          ),
          const Text(
            "Welcome",
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.1,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed("/screens.sign_in");
            },
            child: const Text("LOGIN"),
          )
        ]));
  }
}
