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
            // TODO : This is just a test it must be removed.
            home: Scaffold(
              appBar: AppBar(title: Text(".")),
              body: Center(
                child: ListView.builder(
                  itemCount: themeProvider.getAllThemes()?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return MaterialButton(
                        child: Text(themeProvider.getAllThemes()[index]),
                        onPressed: () => themeBloc.setTheme(
                            themeProvider.getThemeByName(
                                themeProvider.getAllThemes()[index])));
                  },
                ),
              ),
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
