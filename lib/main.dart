import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timeago/timeago.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';

import 'package:quake/src/app.dart';
import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/bloc/bloc_provider.dart';
import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/quake_builders.dart';
import 'package:quake/src/routes/settings.dart';
import 'package:quake/src/themes/theme_provider.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';
import 'package:quake/src/utils/timeago.dart';
import 'package:quake/src/model/earthquake_details.dart';
import 'package:quake/src/utils/connectivity.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/db/earthquake_provider.dart';

/// Main function, returns a [QuakeStreamBuilder] with the whole app as a child,
/// it's rebuilt when a theme is changed.
main() async {
  /// Instance of [QuakeConnectivityHelper], used to save the initial connection,
  /// so it can be accessed by the whole app
  QuakeConnectivityHelper quakeConnectivityHelper = QuakeConnectivityHelper();

  // save connectivity to be accessed syncronously
  quakeConnectivityHelper.connectivity =
      await Connectivity().checkConnectivity();

  /// Instance of [QuakeSharedPreferences], used to instantiate the prefs, so they
  /// can be used by the whole app.
  QuakeSharedPreferences sharedPreferences = QuakeSharedPreferences();

  // init sharedPreferences
  await sharedPreferences.init();

  // initialize database
  await EarthquakesBloc().initializeCacheDatabase();

  bool notificationsEnabled = sharedPreferences.getValue<bool>(
    key: QuakeSharedPreferencesKey.notificationsEnabled,
    defaultValue: false,
  );

  runApp(Quake());

  if (notificationsEnabled)
    BackgroundFetch.registerHeadlessTask(onBackgroundFetch);
}

class Quake extends StatefulWidget {
  @override
  _QuakeState createState() => _QuakeState();
}

class _QuakeState extends State<Quake> {
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

  /// instance of the BLoC used to handle theme change, called when a theme is
  /// changed to rebuild the whole app with the new theme.
  ThemeBloc themeBloc = ThemeBloc();
  QuakeSharedPreferences sharedPreferences = QuakeSharedPreferences();

  bool notificationsEnabled;

  @override
  void initState() {
    super.initState();
    notificationsEnabled = sharedPreferences.getValue<bool>(
      key: QuakeSharedPreferencesKey.notificationsEnabled,
      defaultValue: false,
    );

    if (notificationsEnabled)
      initNotificationsPluginAndBackgroundFetch(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: themeBloc,
      child: QuakeStreamBuilder<ThemeData>(
        stream: themeBloc.themeStream,
        initialData:
            ThemeProvider().getPrefTheme(), // load theme from sharedPreferences
        builder: (context, theme) => MaterialApp(
              localizationsDelegates: [
                QuakeLocalizations.delegate, // custom locale
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              onGenerateTitle: (context) =>
                  QuakeLocalizations.of(context).title,
              supportedLocales: supportedLocales,
              routes: routes,
              theme: theme,
              home: Builder(builder: (ctx) {
                setLocaleMessages(
                  QuakeLocalizations.localeCode,
                  getLocaleStringsClass(QuakeLocalizations.localeCode),
                );

                // initialize dart's date formatter with the current locale code
                initializeDateFormatting(
                  QuakeLocalizations.localeCode,
                  null,
                );

                return Home();
              }),
            ),
      ),
    );
  }
}

void initNotificationsPluginAndBackgroundFetch(BuildContext context) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_logo');
  InitializationSettings initializationSettings =
      InitializationSettings(initializationSettingsAndroid, null);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload == null || payload.isEmpty) return;
    EarthquakesBloc earthquakesBloc = EarthquakesBloc();

    EarthquakePersistentCacheProvider _cache =
        EarthquakePersistentCacheProvider();

    await earthquakesBloc.initializeCacheDatabase();
    try {
      Earthquake earthquake =
          (await _cache.getEarthquakeById(eventID: payload));
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EarthquakeDetails(
                earthquake: earthquake,
              ),
        ),
      );
    } catch (_) {
      return;
    }
  });

  BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 10,
      stopOnTerminate: false,
      enableHeadless: true,
    ),
    onBackgroundFetch,
  );
}

void onBackgroundFetch() async {
  QuakeSharedPreferences sharedPreferences = QuakeSharedPreferences();
  EarthquakesBloc earthquakesBloc = EarthquakesBloc();
  EarthquakePersistentCacheProvider _cache =
      EarthquakePersistentCacheProvider();

  await sharedPreferences.init();
  await earthquakesBloc.initializeCacheDatabase();

  String source = sharedPreferences.getValue<String>(
    key: QuakeSharedPreferencesKey.earthquakesSource,
  );
  Earthquake _lastFetchedEarthquake;
  if (source == null || source.isEmpty)
    _lastFetchedEarthquake = await earthquakesBloc.fetchLast(
      source: EarthquakesListSource.ingv,
    );
  else
    _lastFetchedEarthquake = await earthquakesBloc.fetchLast(
      source: EarthquakesListSource.values
          .singleWhere((s) => s.toString() == source),
    );

  String lastCachedEarthquakeID = sharedPreferences.getValue<String>(
    key: QuakeSharedPreferencesKey.lastEarthquakeID,
    defaultValue: '-1',
  );

  Earthquake _lastCachedEarthquake =
      await _cache.getEarthquakeById(eventID: lastCachedEarthquakeID);

  if (_lastFetchedEarthquake.time != _lastCachedEarthquake.time ||
      lastCachedEarthquakeID == '-1') {
    sharedPreferences.setValue<String>(
      key: QuakeSharedPreferencesKey.lastEarthquakeID,
      value: _lastFetchedEarthquake.eventID,
    );

    await _cache.addEarthquake(earthquake: _lastFetchedEarthquake);

    await sendNotification(_lastFetchedEarthquake);
  }

  BackgroundFetch.finish();
}

sendNotification(Earthquake earthquake) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'Quake-${earthquake.eventID}',
    'Quake',
    'Quake notification channel',
    importance: Importance.Default,
    priority: Priority.Default,
  );
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics,
    null,
  );
  await flutterLocalNotificationsPlugin.show(
    Random.secure().nextInt(1000),
    earthquake.eventLocationName,
    "M: ${earthquake.magnitude} Richter",
    platformChannelSpecifics,
    payload: earthquake.eventID.toString(),
  );
}
