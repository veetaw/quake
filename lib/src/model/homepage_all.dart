import 'package:flutter/material.dart';

import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:quake/src/bloc/home_page_screen_bloc.dart';
import 'package:quake/src/routes/earthquakes_list.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';

final QuakeSharedPreferences sharedPreferences = QuakeSharedPreferences();

class HomePageAll extends StatefulWidget with HomePageScreenBase {
  static HomePageAll _instance = HomePageAll._();
  HomePageAll._();
  factory HomePageAll() => _instance;

  int get index => 0;

  @override
  _HomePageAllState createState() => _HomePageAllState();
}

class _HomePageAllState extends State<HomePageAll> {
  final EarthquakesBloc earthquakesBloc = EarthquakesBloc();

  @override
  Widget build(BuildContext context) {
    String rawSource = sharedPreferences.getValue<String>(
      key: QuakeSharedPreferencesKey.earthquakesSource,
    );

    earthquakesBloc.fetchData(
      source: EarthquakesListSource.values
          .singleWhere((s) => s.toString() == rawSource),
    );

    return Container(
      child: EarthquakesList(
        stream: earthquakesBloc.earthquakes,
        onRefresh: () async => earthquakesBloc.fetchData(force: true),
      ),
    );
  }
}
