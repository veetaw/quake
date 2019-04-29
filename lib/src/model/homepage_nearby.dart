import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:location/location.dart';

import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:quake/src/bloc/home_page_screen_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/alert_dialog.dart';
import 'package:quake/src/routes/earthquakes_list.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';

QuakeSharedPreferences quakeSharedPreferences = QuakeSharedPreferences();

class HomePageNearby extends StatefulWidget with HomePageScreenBase {
  int get index => 1;

  @override
  _HomePageNearbyState createState() => _HomePageNearbyState();
}

class _HomePageNearbyState extends State<HomePageNearby> {
  final EarthquakesBloc earthquakesBloc = EarthquakesBloc();

  @override
  Widget build(BuildContext context) {
    return _hasLocationSaved()
        ? _buildList(location: getLocation())
        : ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: NoLocationSavedWidget(
              callback: () {
                setState(() {});
              },
            ),
          );
  }

  Widget _buildList({Map<String, double> location}) {
    // if location is somehow null prompt for it again
    if (location == null) {
      setState(() => _saveLocation({}, remove: true));
    }

    // create a "bounding box" to check for earthquakes in a circle of 40km radius
    Map newCoordMin = kmOffsetToLatitudeOffset(-30, -30, location);
    Map newCoordMax = kmOffsetToLatitudeOffset(30, 30, location);
    SearchOptions options = SearchOptions(
      minLatitude: newCoordMin["latitude"],
      maxLatitude: newCoordMax["latitude"],
      minLongitude: newCoordMin["longitude"],
      maxLongitude: newCoordMax["longitude"],
      startTime: DateTime.now().subtract(Duration(
        days: 15,
      )),
    );

    earthquakesBloc.search(options: options);
    return EarthquakesList(
      stream: earthquakesBloc.searchedEarthquakes,
      onRefresh: () => earthquakesBloc.search(options: options),
    );
  }
}

class NoLocationSavedWidget extends StatelessWidget {
  final Function callback;

  const NoLocationSavedWidget({
    @required this.callback,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            QuakeLocalizations.of(context).locationNotEnabled,
            style: TextStyle(
              color: Theme.of(context).textTheme.title.color,
              fontSize: 18.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
          ),
          FlatButton(
            child: Text(
              QuakeLocalizations.of(context).promptForLocationPermissionButton,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onPressed: () => QuakeAlertDialog.createDialog(
                  context,
                  QuakeAlertDialog(
                    content: QuakeLocalizations.of(context)
                        .locationPromptAlertContent,
                    title:
                        QuakeLocalizations.of(context).locationPromptAlertTitle,
                    onCancelPressed: () => Navigator.pop(context),
                    onOkPressed: () async {
                      Location location = new Location();

                      Map<String, double> currentLocation = Map();

                      try {
                        LocationData data = await location.getLocation();
                        currentLocation = {
                          "latitude": data.latitude,
                          "longitude": data.longitude,
                        };
                      } on PlatformException catch (_) {
                        currentLocation = null;
                      }
                      if (currentLocation != null) {
                        _saveLocation(currentLocation);
                        callback();
                      }
                      Navigator.pop(context);
                    },
                  ),
                  dismissible: true,
                ),
          ),
        ],
      ),
    );
  }
}

bool _hasLocationSaved() => quakeSharedPreferences.getValue<bool>(
      key: QuakeSharedPreferencesKey.hasLocationSaved,
      defaultValue: false,
    );

_saveLocation(Map<String, double> location, {bool remove: false}) {
  quakeSharedPreferences.setValue<double>(
    key: QuakeSharedPreferencesKey.latitude,
    value: location["latitude"] ?? null,
  );

  quakeSharedPreferences.setValue<double>(
    key: QuakeSharedPreferencesKey.longitude,
    value: location["longitude"] ?? null,
  );

  quakeSharedPreferences.setValue<bool>(
    key: QuakeSharedPreferencesKey.hasLocationSaved,
    value: !remove,
  );
}

Map<String, double> getLocation() {
  Map<String, double> location = Map();
  location["latitude"] = quakeSharedPreferences.getValue<double>(
    key: QuakeSharedPreferencesKey.latitude,
  );

  location["longitude"] = quakeSharedPreferences.getValue<double>(
    key: QuakeSharedPreferencesKey.longitude,
  );

  return location;
}

Map kmOffsetToLatitudeOffset(num deltaLat, num deltaLon, Map oldCoordinates) {
  const double earthRadius = 6378;

  double latitude =
      oldCoordinates["latitude"] + (deltaLat / earthRadius) * (180 / pi);
  double longitude = oldCoordinates["longitude"] +
      (deltaLon / earthRadius) * (180 / pi) / cos(latitude * pi / 180);

  return <String, double>{
    "latitude": latitude,
    "longitude": longitude,
  };
}
