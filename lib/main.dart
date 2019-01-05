import 'package:quake/src/app.dart';
import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/routes/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<bool> isFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  /// query SharedPreferences for a bool named firstTime, if it's not present in the "DB" return true
  bool firstTime = prefs.getBool("firstTime") ?? true;

  /// if it's the first time now it won't be the next time, so set it to false  D:
  if (firstTime) prefs.setBool("firstTime", false);

  return firstTime;
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
              builder: (context, snapshot) =>
                  snapshot.data ?? true ? LandingPage() : Home(),
            ),
          ),
    ),
  );
}
