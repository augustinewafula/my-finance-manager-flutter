import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../config/size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    required Key key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: getProportionateScreenHeight(56),
        child: CupertinoButton(
          onPressed: onPressed,
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
          padding: EdgeInsets.all(getProportionateScreenHeight(5)),
          child: Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenHeight(18),
              color: Colors.white,
            ),
          ),
        ));
  }
}
