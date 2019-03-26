import 'package:flutter/material.dart';
import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:quake/src/bloc/home_page_screen_bloc.dart';
import 'package:quake/src/routes/earthquakes_list.dart';

final EarthquakesBloc earthquakesBloc = EarthquakesBloc();

class HomePageAll extends StatelessWidget with HomePageScreenBase {
  int get index => 0;

  static HomePageAll _instance = HomePageAll._();
  HomePageAll._();
  factory HomePageAll() => _instance;

  @override
  Widget build(BuildContext context) {
    earthquakesBloc.fetchData();

    return Container(
      child: EarthquakesList(earthquakesBloc: earthquakesBloc),
    );
  }
}
