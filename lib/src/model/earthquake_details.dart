import 'package:flutter/material.dart' hide VerticalDivider;

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:quake/src/model/quake_builders.dart';
import 'package:quake/src/utils/map_url.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';
import 'package:quake/src/utils/unit_of_measurement_conversion.dart';
import 'package:timeago/timeago.dart';
import 'package:share/share.dart';

import 'package:quake/src/data/osm_nominatim.dart';
import 'package:quake/src/data/population.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/model/vertical_divider.dart';

final QuakeSharedPreferences quakeSharedPreferences = QuakeSharedPreferences();

class EarthquakeDetails extends StatelessWidget {
  static const routeName = '/details';

  final Earthquake earthquake;

  const EarthquakeDetails({
    Key key,
    this.earthquake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double paddingBetween = 10;
    final TileLayerOptions tileLayerOptions = TileLayerOptions(
      urlTemplate: _getTemplateUrl(),
      subdomains: ['a', 'b', 'c'],
    );

    UnitOfMeasurement currentUnitOfMeasurement =
        UnitOfMeasurementConversion.unitOfMeasurementFromString(
      quakeSharedPreferences.getValue<String>(
        key: QuakeSharedPreferencesKey.unitOfMeasurement,
        defaultValue: UnitOfMeasurement.kilometers.toString(),
      ),
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2 - 56,
              child: _buildStaticMap(tileLayerOptions),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _buildLeftTile(
                            context,
                            paddingBetween,
                            earthquake.magnitude.toString(),
                            QuakeLocalizations.of(context).magnitude),
                        Padding(
                          padding: EdgeInsets.only(
                            top: paddingBetween,
                          ),
                        ),
                        _buildLeftTile(
                          context,
                          paddingBetween,
                          // convert depth to the current unit of measurement.
                          UnitOfMeasurementConversion.convertTo(
                            kmValue: earthquake.depth,
                            unit: currentUnitOfMeasurement,
                          ).toString(),
                          QuakeLocalizations.of(context).depth +
                              " (" +
                              QuakeLocalizations.of(context).unitOfMeasurement(
                                currentUnitOfMeasurement,
                                short: true,
                              ) +
                              ")",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    child: VerticalDivider(
                      width: 2,
                      height: MediaQuery.of(context).size.height / 2,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Expanded(
                    // right infos
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            _buildRightTile(
                              context,
                              paddingBetween,
                              Icons.access_time,
                              DateFormat.yMMMMd()
                                  .format(earthquake.time)
                                  .toString(),
                              DateFormat.Hm()
                                  .format(earthquake.time)
                                  .toString(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: paddingBetween,
                              ),
                            ),
                            QuakeFutureBuilder<Map>(
                                future: OpenStreetMapNominatim().reverseGeo(
                                  latitude: earthquake.latitude,
                                  longitude: earthquake.longitude,
                                  language: QuakeLocalizations.localeCode,
                                ),
                                onError: (_) => _buildRightTile(
                                      context,
                                      paddingBetween,
                                      Icons.location_on,
                                      earthquake.eventLocationName,
                                      "",
                                    ),
                                onLoading: () => _buildRightTile(
                                      context,
                                      paddingBetween,
                                      Icons.location_on,
                                      earthquake.eventLocationName,
                                      "",
                                    ),
                                builder: (context, data) {
                                  if (data == null || data["address"] == null)
                                    return _buildRightTile(
                                      context,
                                      paddingBetween,
                                      Icons.location_on,
                                      earthquake.eventLocationName,
                                      "",
                                    );

                                  return _buildRightTile(
                                    context,
                                    paddingBetween,
                                    Icons.location_on,
                                    // good game osm for consistency ...
                                    data["address"]["village"] ??
                                        data["address"]["town"] ??
                                        data["address"]["city"] ??
                                        data["address"]["hamlet"] ??
                                        data["display_name"],
                                    data["address"]["country"],
                                  );
                                }),
                            Padding(
                              padding: EdgeInsets.only(
                                top: paddingBetween,
                              ),
                            ),
                            QuakeFutureBuilder<Map>(
                              future: getPopulationByCoordinates(
                                latitude: earthquake.latitude,
                                longitude: earthquake.longitude,
                              ),
                              onLoading: () => _buildRightTile(
                                    context,
                                    paddingBetween,
                                    Icons.people,
                                    QuakeLocalizations.of(context)
                                        .peopleInvolved,
                                    "...",
                                  ),
                              onError: (_) => _buildRightTile(
                                    context,
                                    paddingBetween,
                                    Icons.people,
                                    QuakeLocalizations.of(context)
                                        .peopleInvolved,
                                    "0",
                                  ),
                              builder: (context, data) {
                                return _buildRightTile(
                                  context,
                                  paddingBetween,
                                  Icons.people,
                                  QuakeLocalizations.of(context).peopleInvolved,
                                  data["results"][0]["value"]["estimates"]
                                          ["gpw-v4-population-count-rev10_2020"]
                                      ["SUM"],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlutterMap _buildStaticMap(TileLayerOptions tileLayerOptions) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(earthquake.latitude, earthquake.longitude),
        zoom: 8.0,
        interactive: false,
      ),
      layers: [
        tileLayerOptions,
        MarkerLayerOptions(
          markers: [
            Marker(
              point: LatLng(earthquake.latitude, earthquake.longitude),
              builder: (BuildContext context) {
                return FlareActor(
                  "assets/flare/pulse.flr",
                  animation: "final animation",
                  color: Theme.of(context).primaryColor,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  SizedBox _buildRightTile(
    BuildContext context,
    double paddingBetween,
    IconData icon,
    String title,
    String subtitle,
  ) =>
      SizedBox(
        width: double.infinity,
        height: (MediaQuery.of(context).size.height / 2) / 4 - paddingBetween,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              icon,
              size: 16,
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  SizedBox _buildLeftTile(
    BuildContext context,
    num paddingBetween,
    String title,
    String description,
  ) =>
      SizedBox(
        width: double.infinity,
        height: (MediaQuery.of(context).size.height / 2) / 2.5 - paddingBetween,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      );

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      brightness: Theme.of(context)
          .brightness, // make status bar icons dark or light depending on the brightness
      centerTitle: Theme.of(context).platform ==
          TargetPlatform.iOS, // center title if running on ios
      primary: true,
      title: Text(QuakeLocalizations.of(context).earthquake),
      elevation: 0,
      automaticallyImplyLeading: true,
      actions: <Widget>[
        LayoutBuilder(
          builder: (context, constraints) {
            return IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      QuakeLocalizations.of(context).loadingEarthquakeInfos,
                    ),
                  ),
                );
                await initializeDateFormatting(
                  QuakeLocalizations.localeCode,
                  null,
                );
                Map locationInfos = await OpenStreetMapNominatim().reverseGeo(
                  latitude: earthquake.latitude,
                  longitude: earthquake.longitude,
                  language: QuakeLocalizations.localeCode,
                );
                if (locationInfos["error"] != null)
                  return Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        QuakeLocalizations.of(context).shareNotAvailable,
                      ),
                    ),
                  );
                String locationName = locationInfos["address"]["village"] ??
                    locationInfos["address"]["town"] ??
                    locationInfos["address"]["city"] ??
                    locationInfos["address"]["hamlet"] ??
                    locationInfos["display_name"];
                String country = locationInfos["address"]["country"];

                return Share.share(
                  QuakeLocalizations.of(context).shareIntentText(
                    locationName,
                    earthquake.magnitude.toString(),
                    country,
                    format(
                      earthquake.time,
                      locale: QuakeLocalizations.localeCode,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

String _getTemplateUrl() {
  String rawTemplateEnumString = quakeSharedPreferences.getValue<String>(
    key: QuakeSharedPreferencesKey.mapTilesProvider,
  );

  return getUrlByMapStyle(getMapStyleByString(rawTemplateEnumString));
}
