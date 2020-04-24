import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:quake/models/earthquake.dart';

class DetailsPreview extends StatelessWidget {
  final Earthquake earthquake;

  const DetailsPreview({
    @required this.earthquake,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double width = mediaQuery.size.width;
    final double height = mediaQuery.size.height;

    final bool isPortrait = mediaQuery.orientation == Orientation.portrait;

    final double dialogHeight = height / 2;
    final double dialogWidth = width - 64;

    // todo: add hero for animation
    return BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: 8.0,
        sigmaY: 8.0,
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: dialogHeight,
          width: dialogWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: dialogHeight / 2,
                width: dialogWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: FlutterMap(
                    options: MapOptions(
                      center: earthquake.coordinates.asLatLng(),
                      zoom: 8.0,
                      interactive: false,
                    ),
                    layers: <LayerOptions>[
                      TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(
                        markers: <Marker>[
                          Marker(
                            point: earthquake.coordinates.asLatLng(),
                            builder: (context) =>
                                ColoredBox(color: Colors.red), // TODO
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                child: Container(
                  width: dialogWidth / 1.5,
                  alignment: Alignment.center,
                  child: Text("Full details"),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
