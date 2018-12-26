import 'package:flutter/material.dart';
import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/themes/theme_provider.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  ThemeBloc themeBloc = ThemeBloc();
  ThemeProvider themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: themeBloc.theme,
      initialData: ThemeData.light(),
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) =>
          MaterialApp(
            theme: snapshot.data,
          ),
    );
  }

  @override
  void dispose() {
    themeBloc.dispose();
    super.dispose();
  }
}
