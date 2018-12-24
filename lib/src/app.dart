import 'package:flutter/material.dart';
import 'package:quake/src/bloc/theme_bloc.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  ThemeBloc themeBloc = ThemeBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: themeBloc.theme,
      initialData: ThemeData.light(),
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) =>
          MaterialApp(
            home: Scaffold(
              body: Text('not first time'),
            ),
          ),
    );
  }

  @override
  void dispose() {
    themeBloc.dispose();
    super.dispose();
  }
}
