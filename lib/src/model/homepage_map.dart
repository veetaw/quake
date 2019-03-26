import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:quake/src/bloc/home_page_screen_bloc.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/model/homepage_nearby.dart' show getLocation;
import 'package:quake/src/model/loading.dart';
import 'package:quake/src/themes/quake_icons.dart';

final EarthquakesBloc earthquakesBloc = EarthquakesBloc();

class HomePageMap extends StatefulWidget with HomePageScreenBase {
  int get index => 2;
  @override
  HomePageMapState createState() => HomePageMapState();
}

class HomePageMapState extends State<HomePageMap>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getLocation(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.data == null) return Loading();
          if (snapshot.hasData) {
            bool hasLocationSaved = !(snapshot.data["latitude"] == -1 ||
                snapshot.data["longitude"] == -1);
            Map coord = snapshot.data;
            earthquakesBloc.fetchData();
            return StreamBuilder(
              stream: earthquakesBloc.earthquakes,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Earthquake>> snapshot) {
                List<Marker> markers = List();
                if (snapshot.hasData) {
                  markers = snapshot.data
                      .where((earthquake) => earthquake.magnitude > 1.5)
                      .map(
                        (earthquake) => Marker(
                              point: LatLng(
                                earthquake.latitude,
                                earthquake.longitude,
                              ),
                              builder: (_) => LocationMarker(
                                    earthquake: earthquake,
                                    markColor: earthquake.magnitude > 2.0
                                        ? Colors.red
                                        : Colors.green,
                                    text: earthquake.magnitude.toString(),
                                  ),
                            ),
                      )
                      .toList();
                }
                return FlutterMap(
                  options: MapOptions(
                    center: hasLocationSaved
                        ? LatLng(
                            coord["latitude"],
                            coord["longitude"],
                          )
                        : null,
                    zoom: 5.0,
                    minZoom: 2.0,
                    maxZoom: 10.0,
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
                          point: hasLocationSaved
                              ? LatLng(
                                  coord["latitude"],
                                  coord["longitude"],
                                )
                              : null,
                          builder: (BuildContext context) => LocationMarker(
                                markColor: Theme.of(context).accentColor,
                              ),
                        )
                      ]..addAll(markers),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class LocationMarker extends StatelessWidget {
  final String text;
  final Color markColor;
  final Color iconColor;
  final Earthquake earthquake;

  LocationMarker({this.text, this.markColor, this.iconColor, this.earthquake});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) =>
          print(details.globalPosition), // TODO: show overlay at this position
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Icon(
            QuakeIcons.location,
            size: 43,
            color: markColor ?? Theme.of(context).accentColor,
          ),
          text == null
              ? Padding(
                  padding: EdgeInsets.only(left: 10.5, top: 5),
                  child: Icon(
                    Icons.home,
                    size: 22,
                    color: iconColor ?? Theme.of(context).canvasColor,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 12, top: 9),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryTextTheme.title.color,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
