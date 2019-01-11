import 'package:flutter/material.dart';
import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:quake/src/model/earthquake_card.dart';

final EarthquakesBloc earthquakesBloc = EarthquakesBloc();

class HomePageAll extends StatelessWidget {
  static HomePageAll _instance = HomePageAll._();
  HomePageAll._();
  factory HomePageAll() => _instance;

  @override
  Widget build(BuildContext context) {
    earthquakesBloc.fetchData();

    return Container(
      child: StreamBuilder(
        stream: earthquakesBloc.earthquakes,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasError)
            return Container(
              child: Text("error"),
            ); // TODO:
          else if (snapshot.hasData)
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) => EarthquakeCard(
                    earthquake: snapshot.data[index],
                    onTap: () {},
                  ),
            );
          else
            return CircularProgressIndicator(); // TODO:
        },
      ),
    );
  }
}
