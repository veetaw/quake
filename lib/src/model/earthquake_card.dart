import 'package:flutter/material.dart';
import 'package:quake/src/model/earthquake.dart';

class EarthquakeCard extends StatelessWidget {
  final Earthquake earthquake;
  final GestureTapCallback onTap;

  EarthquakeCard({
    @required this.earthquake,
    @required this.onTap,
  }) : assert(earthquake != null);

  static const double _kCardHeight = 160;
  static const double _kCardElevation = 2;
  final ShapeBorder _kCardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  );
  static const EdgeInsets _kMarginBetween = EdgeInsets.all(9.0);
  static const double _kEarthquakeLocationNameSize = 20;
  static const double _kEarthquakeDateSize = 16;
  static const double _kEarthquakeHourSize = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // as wide as the screen
      height: _kCardHeight,
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: _kCardElevation,
        shape: _kCardShape,
        margin: _kMarginBetween,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildText(
                context: context,
                text: earthquake.eventLocationName,
                size: _kEarthquakeLocationNameSize,
              ),
              _buildText(
                context: context,
                text: earthquake.eventLocationName,
                size: _kEarthquakeDateSize,
                weight: FontWeight.w300,
              ),
              _buildText(
                context: context,
                text: earthquake.eventLocationName,
                size: _kEarthquakeHourSize,
                weight: FontWeight.w200,
              )
            ],
          ),
        ),
      ),
    );
  }

  Text _buildText({
    @required BuildContext context,
    @required String text,
    @required double size,
    FontWeight weight = FontWeight.w400,
  }) =>
      Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          // fontFamily: 'Roboto', TODO
          fontStyle: FontStyle.normal,
          fontSize: size,
          fontWeight: weight,
          color: Theme.of(context).textTheme.title.color,
        ),
      );
}
