import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
