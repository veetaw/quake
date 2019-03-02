import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/model/vertical_divider.dart'
    as vd; // to ignore ambiguos import

class EarthquakeDetails extends StatelessWidget {
  final Earthquake earthquake;

  const EarthquakeDetails({Key key, this.earthquake}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
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
                ],
              ), // FlutterMap
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    // left infos
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // tile
                        // padding
                        // tile
                        // padding
                        // tile
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                            ListTile(), // date
                            ListTile(), // location
                            ListTile(), // people involved
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
    );
  }
}
