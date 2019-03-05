import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:quake/src/data/osm_nominatim.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/model/vertical_divider.dart' as vd;
import 'package:quake/src/themes/quake_icons.dart'; // to ignore ambiguos import

class EarthquakeDetails extends StatelessWidget {
  final Earthquake earthquake;

  const EarthquakeDetails({Key key, this.earthquake}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double paddingBetween = 10;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2 - 56,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(earthquake.latitude, earthquake.longitude),
                  zoom: 8.0,
                  interactive: false,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        point:
                            LatLng(earthquake.latitude, earthquake.longitude),
                        builder: (BuildContext context) {
                          // TODO: use an animation instead of the marker
                          // FlareActor(
                          //   "assets/flare/pulsing circle.flr",
                          //   animation: "Untitled",
                          // );
                          return Icon(
                            QuakeIcons.location,
                            color: Theme.of(context).errorColor,
                            size: 45,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
                          earthquake.depth.toString(),
                          QuakeLocalizations.of(context).depth,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    child: vd.VerticalDivider(
                      // divider
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
                            FutureBuilder(
                              future: initializeDateFormatting(
                                QuakeLocalizations.localeCode,
                                null,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done)
                                  return Container(
                                    child: CircularProgressIndicator(),
                                  );
                                return _buildRightTile(
                                  context,
                                  paddingBetween,
                                  Icons.access_time,
                                  DateFormat.yMMMMd()
                                      .format(earthquake.time)
                                      .toString(),
                                  DateFormat.Hm()
                                      .format(earthquake.time)
                                      .toString(),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: paddingBetween,
                              ),
                            ),
                            FutureBuilder(
                                future: OpenStreetMapNominatim().reverseGeo(
                                  latitude: earthquake.latitude,
                                  longitude: earthquake.longitude,
                                  language: QuakeLocalizations.localeCode,
                                ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData && !snapshot.hasError)
                                    return Container(
                                      child: CircularProgressIndicator(),
                                    );
                                  if (snapshot.hasError ||
                                      snapshot.data["error"] != null)
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
                                    snapshot.data["address"]["village"] ??
                                        snapshot.data["address"]["town"] ??
                                        snapshot.data["address"]["city"] ??
                                        snapshot.data["address"]["hamlet"] ??
                                        snapshot.data["display_name"],
                                    snapshot.data["address"]["country"],
                                  );
                                }),
                            Padding(
                              padding: EdgeInsets.only(
                                top: paddingBetween,
                              ),
                            ),
                            _buildRightTile(
                              context,
                              paddingBetween,
                              Icons.people,
                              QuakeLocalizations.of(context).peopleInvolved,
                              "TODO",
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
        height: (MediaQuery.of(context).size.height / 2) / 3 - paddingBetween,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 60,
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
      backgroundColor: Theme.of(context).bottomAppBarColor,
      brightness: Theme.of(context)
          .brightness, // make status bar icons dark or light depending on the brightness
      centerTitle: Theme.of(context).platform ==
          TargetPlatform.iOS, // center title if running on ios
      primary: true,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      title: Text(QuakeLocalizations.of(context).earthquake),
      elevation: 0,
      automaticallyImplyLeading: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () => null, // todo: share
        ),
      ],
    );
  }
}
