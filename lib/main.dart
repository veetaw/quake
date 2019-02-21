import 'package:quake/src/app.dart';
import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/loading.dart';
import 'package:quake/src/routes/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<bool> isFirstTime() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // query SharedPreferences for a bool named firstTime, if it's not present in the "DB" return true
  return sharedPreferences.getBool("firstTime") ?? true;
}

main() async {
  ThemeBloc themeBloc = ThemeBloc();

  return runApp(
    StreamBuilder(
      stream: themeBloc.theme,
      initialData: ThemeData.light(),
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) =>
          MaterialApp(
            localizationsDelegates: [
              QuakeLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            onGenerateTitle: (context) => QuakeLocalizations.of(context).title,
            supportedLocales: [
              Locale('en'),
              Locale('it'),
            ],
            routes: {
              Home.routeName: (_) => Home(),
            },
            theme: snapshot.data,
            home: FutureBuilder(
              future: isFirstTime(),
              builder: (context, snapshot) {
                if (snapshot.data == null) return Loading();
                return snapshot.data ? LandingPage() : Home();
              },
            ),
          ),
    ),
  );
}
