import 'package:flutter/material.dart';
import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/earthquake_card.dart';
import 'package:quake/src/model/earthquake_details.dart';
import 'package:quake/src/model/loading.dart';

import 'package:quake/src/model/error.dart' as error;

class EarthquakesList extends StatelessWidget {
  const EarthquakesList({
    @required this.earthquakesBloc,
  });

  final EarthquakesBlocBase earthquakesBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: earthquakesBloc.earthquakes,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.data == null) return Loading();

        if (snapshot.hasError) {
          if (snapshot.error == "no results")
            return error.ErrorWidget(
              message: QuakeLocalizations.of(context).noEarthquakesNearby,
              icon: Icons.sentiment_very_satisfied,
            );
          else
            return error.ErrorWidget(
              message: QuakeLocalizations.of(context).allEarthquakesError,
              size: 50,
            );
        } else if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return error.ErrorWidget(
              message: QuakeLocalizations.of(context).noEarthquakesNearby,
              icon: Icons.sentiment_very_satisfied,
            );
          else
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (
                BuildContext context,
                int index,
              ) =>
                  EarthquakeCard(
                    earthquake: snapshot.data[index],
                    onTap: () => Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => EarthquakeDetails(
                                  earthquake: snapshot.data[index],
                                ),
                            transitionsBuilder: (
                              BuildContext context,
                              Animation animation,
                              Animation secondaryAnimation,
                              Widget child,
                            ) =>
                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset.zero,
                                      end: Offset(1, 0),
                                    ).animate(secondaryAnimation),
                                    child: child,
                                  ),
                                ),
                          ),
                        ),
                  ),
            );
        }
        return Loading();
      },
    );
  }
}
