import 'dart:async';

import 'package:quake/src/app.dart';
import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/loading.dart';
import 'package:quake/src/routes/landing_page.dart';
import 'package:quake/src/routes/settings.dart';
import 'package:quake/src/themes/theme_provider.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';
import 'package:quake/src/utils/timeago.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<bool> isFirstTime() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // query SharedPreferences for a bool named firstTime, if it's not present in the "DB" return true
  return sharedPreferences.getBool("firstTime") ?? true;
}

main() async {
  QuakeSharedPreferences().init();

  ThemeBloc themeBloc = ThemeBloc();
  ThemeProvider themeProvider = ThemeProvider();

  return runApp(
    StreamBuilder(
      stream: themeBloc.themeStream,
      initialData: themeProvider.getPrefTheme(),
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
              Settings.routeName: (_) => Settings(),
            },
            theme: snapshot.data,
            home: FutureBuilder(
              future: isFirstTime(),
              builder: (context, snapshot) {
                timeago.setLocaleMessages(
                  QuakeLocalizations.localeCode,
                  getLocaleStringsClass(QuakeLocalizations.localeCode),
                );
                if (snapshot.data == null) return Loading();
                return snapshot.data ? LandingPage() : Home();
              },
            ),
          ),
    ),
  );
}
