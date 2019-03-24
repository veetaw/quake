import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timeago/timeago.dart';
import 'package:connectivity/connectivity.dart';

import 'package:quake/src/app.dart';
import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/quake_builders.dart';
import 'package:quake/src/routes/landing_page.dart';
import 'package:quake/src/routes/settings.dart';
import 'package:quake/src/themes/theme_provider.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';
import 'package:quake/src/utils/timeago.dart';
import 'package:quake/src/model/earthquake_details.dart';
import 'package:quake/src/utils/connectivity.dart';

/// Main function, returns a [QuakeStreamBuilder] with the whole app as a child,
/// it's rebuilt when a theme is changed.
main() async {
  /// Instance of [QuakeConnectivityHelper], used to save the initial connection,
  /// so it can be accessed by the whole app
  QuakeConnectivityHelper quakeConnectivityHelper = QuakeConnectivityHelper();

  // save connectivity to be accessed syncronously
  quakeConnectivityHelper.connectivity = await Connectivity().checkConnectivity();

  /// Instance of [QuakeSharedPreferences], used to instantiate the prefs, so they
  /// can be used by the whole app.
  QuakeSharedPreferences sharedPreferences = QuakeSharedPreferences();

  // init sharedPreferences
  await sharedPreferences.init();

  /// Checks if the user has already finished the [LandingPage] before.
  bool isFirstTime = sharedPreferences.getValue<bool>(
    key: QuakeSharedPreferencesKey.firstTime,
    defaultValue: true,
  );

  /// Supported language translations for Quake.
  ///
  /// They're defined in [_QuakeLocalizationsDelegate.supportedLocales]
  final List<Locale> supportedLocales = [
    Locale('en'),
    Locale('it'),
  ];

  /// Quake's entry points.
  final Map<String, WidgetBuilder> routes = {
    Home.routeName: (_) => Home(),
    Settings.routeName: (_) => Settings(),
    EarthquakeDetails.routeName: (_) => EarthquakeDetails(),
  };

  return runApp(
    QuakeStreamBuilder<ThemeData>(
      stream: ThemeBloc().themeStream,
      initialData:
          ThemeProvider().getPrefTheme(), // load theme from sharedPreferences
      builder: (context, theme) => MaterialApp(
            localizationsDelegates: [
              QuakeLocalizations.delegate, // custom locale
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            onGenerateTitle: (context) => QuakeLocalizations.of(context).title,
            supportedLocales: supportedLocales,
            routes: routes,
            theme: theme,
            home: LayoutBuilder(builder: (context, _) {
              setLocaleMessages(
                QuakeLocalizations.localeCode,
                getLocaleStringsClass(QuakeLocalizations.localeCode),
              );

              return isFirstTime ? LandingPage() : Home();
            }),
          ),
    ),
  );
}
