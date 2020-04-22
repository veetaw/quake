import 'package:flutter/material.dart';

class LogoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 32,
          height: 32,
          child: Image.asset(
            "assets/icon/logo_no_bg.png",
          ),
        ),
        Text(
          "uake",
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }
}
