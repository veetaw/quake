import 'package:flutter/material.dart';

import 'package:quake/screens/home/home.dart';

void main() {
  runApp(Quake());
}

class Quake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      home: Home(),
    );
  }
}
