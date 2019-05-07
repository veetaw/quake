import 'dart:async';

import 'package:flutter/material.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:meta/meta.dart';
import 'package:quake/src/data/ingv_api.dart';

import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/model/earthquake_card.dart';
import 'package:quake/src/model/earthquake_details.dart';
import 'package:quake/src/model/error.dart';
import 'package:quake/src/model/quake_builders.dart';

class EarthquakesList extends StatelessWidget {
  final Stream<List<Earthquake>> stream;
  final Function onRefresh;

  const EarthquakesList({
    @required this.stream,
    @required this.onRefresh,
    Key key,
  })  : assert(stream != null),
        assert(onRefresh != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    print("called");
    return QuakeStreamBuilder<List<Earthquake>>(
      stream: stream,
      onError: (e) => handleError(e, context),
      builder: (context, list) {
        return (list ?? []).length != 0
            ? LiquidPullToRefresh(
                onRefresh: onRefresh,
                showChildOpacityTransition: false,
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).canvasColor,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) =>
                      EarthquakeCard(
                        earthquake: list[index],
                        onTap: () => startDetailPage(
                              context,
                              list[index],
                            ),
                      ),
                ),
              )
            : QuakeErrorWidget(
                message: QuakeLocalizations.of(context).noEarthquakes,
                icon: Icons.sentiment_very_satisfied,
              );
      },
    );
  }
}

void startDetailPage(BuildContext context, Earthquake earthquake) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => EarthquakeDetails(
            earthquake: earthquake,
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
  );
}

Widget handleError(Object e, BuildContext context) {
  switch (e) {
    case NoResponseException:
      return QuakeErrorWidget(
        message: QuakeLocalizations.of(context).noResponse,
        icon: Icons.sentiment_dissatisfied,
      );
    case NoContentException:
      return QuakeErrorWidget(
        message: QuakeLocalizations.of(context).noEarthquakes,
        icon: Icons.sentiment_very_satisfied,
      );
    case NoEarthquakesException:
      return QuakeErrorWidget(
        message: QuakeLocalizations.of(context).noEarthquakes,
        icon: Icons.sentiment_very_satisfied,
      );
    case MalformedResponseException:
      return QuakeErrorWidget(
        message: QuakeLocalizations.of(context).malformedResponse,
        icon: Icons.sentiment_dissatisfied,
      );
    case BadResponseException:
      return QuakeErrorWidget(
        message: QuakeLocalizations.of(context).badResponse,
        icon: Icons.sentiment_dissatisfied,
      );
    default:
      // unexpected exception happened here
      return QuakeErrorWidget(
        message: QuakeLocalizations.of(context).unexpectedException(e),
        icon: Icons.sentiment_dissatisfied,
      );
  }
}
