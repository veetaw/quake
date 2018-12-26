import 'package:flutter/material.dart';
import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/routes/landing_page.dart';
import 'package:quake/src/themes/theme_provider.dart';

class Home extends StatefulWidget {
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
    // this dispose will be called when the whole app is being closed, so dispose ThemeBloc.
    ThemeBloc().dispose();
    super.dispose();
  }
}
