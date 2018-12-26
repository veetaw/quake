import 'package:flutter/material.dart';
import 'package:quake/src/app.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(child: Text('first time')),
        ],
      ),
    );
  }
}
