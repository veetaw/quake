import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/themes/quake_icons.dart';
import 'package:quake/src/model/vertical_divider.dart'
    as vd; // to ignore ambiguos import

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
  static const EdgeInsets _kCardMargin = EdgeInsets.all(9.0);
  static const double _kEarthquakeLocationNameSize = 20;
  static const double _kEarthquakeDateSize = 16;
  static const double _kEarthquakeHourSize = 14;
  static const double _kPaddingBetweenText = 9;
  static const double _kPaddingTopBottomInfos = 2;
  static const double _kCardContentPadding = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // as wide as the screen
      height: _kCardHeight,
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: _kCardElevation,
        shape: _kCardShape,
        margin: _kCardMargin,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(_kCardContentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildText(
                  context: context,
                  text: earthquake.eventLocationName,
                  size: _kEarthquakeLocationNameSize,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _kPaddingBetweenText,
                    vertical: _kPaddingBetweenText / 2,
                  ),
                ),
                FutureBuilder(
                  // TODO: check if this works
                  future: initializeDateFormatting(
                    QuakeLocalizations.localeCode,
                    null,
                  ),
                  builder: (context, _) => _buildText(
                        context: context,
                        text: DateFormat.yMMMMd()
                            .format(earthquake.time)
                            .toString(),
                        size: _kEarthquakeDateSize,
                        weight: FontWeight.w300,
                      ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _kPaddingBetweenText,
                    vertical: _kPaddingBetweenText / 2,
                  ),
                ),
                _buildText(
                  context: context,
                  text: DateFormat.Hm(QuakeLocalizations.localeCode)
                      .format(earthquake.time),
                  size: _kEarthquakeHourSize,
                  weight: FontWeight.w200,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: _kPaddingTopBottomInfos,
                  ),
                ),
                _EarthquakeCardBottomInfos(
                  earthquake: earthquake,
                ),
              ],
            ),
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

class _EarthquakeCardBottomInfos extends StatelessWidget {
  final Earthquake earthquake;

  _EarthquakeCardBottomInfos({
    @required this.earthquake,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _EarthquakeCardBottomTile(
          title: earthquake.magnitude.toString(),
          subtitle: QuakeLocalizations.of(context).magnitude,
          icon: QuakeIcons.pulse,
        ),
        vd.VerticalDivider(),
        _EarthquakeCardBottomTile(
          title: earthquake.depth.toString(), // TODO add unit of measurement
          subtitle: QuakeLocalizations.of(context).depth,
          icon: QuakeIcons.earth,
        ),
      ],
    );
  }
}

class _EarthquakeCardBottomTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _EarthquakeCardBottomTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: ListTile(
          leading: Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Column(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  // fontFamily: 'Roboto', TODO
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.title.color,
                ),
              ),
              Text(
                subtitle.toUpperCase(),
                style: TextStyle(
                  // fontFamily: 'Roboto', TODO
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).textTheme.title.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
