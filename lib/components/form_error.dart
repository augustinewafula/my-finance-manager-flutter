import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/size_config.dart';

class FormError extends StatelessWidget {
  const FormError({
    required Key key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/error.svg",
          width: getProportionateScreenWidth(14),
          height: getProportionateScreenWidth(14),
        ),
        SizedBox(
            height: getProportionateScreenHeight(10),
            width: getProportionateScreenWidth(4)),
        Container(
            constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth - 84),
            child: Text(error)),
        SizedBox(height: getProportionateScreenHeight(10))
      ],
    );
  }
}
