import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter_map/plugin_api.dart';

import 'package:k_means_cluster/k_means_cluster.dart';
import 'package:latlong/latlong.dart' hide Path;
import 'package:meta/meta.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:quake/src/bloc/home_page_screen_bloc.dart';
import 'package:quake/src/routes/earthquakes_list.dart' show startDetailPage;
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/model/quake_builders.dart';
import 'package:quake/src/utils/map_url.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';

/// Instance of QuakeSharedPreferences
QuakeSharedPreferences quakeSharedPreferences = QuakeSharedPreferences();

class HomePageMap extends StatefulWidget with HomePageScreenBase {
  /// Index for BottomAppBar
  int get index => 2;

  @override
  HomePageMapState createState() => HomePageMapState();
}

class HomePageMapState extends State<HomePageMap> {
  /// Instance of the BLoC used to fetch earthquakes
  final EarthquakesBloc earthquakesBloc = EarthquakesBloc();

  @override
  Widget build(BuildContext context) {
    earthquakesBloc.fetchData();
    return QuakeStreamBuilder<List<Earthquake>>(
      stream: earthquakesBloc.earthquakes,
      builder: (context, data) {
        return EarthquakeMap(data: data);
      },
    );
  }
}

class EarthquakeMap extends StatefulWidget {
  final List<Earthquake> data;

  const EarthquakeMap({Key key, @required this.data}) : super(key: key);

  @override
  _EarthquakeMapState createState() => _EarthquakeMapState();
}

class _EarthquakeMapState extends State<EarthquakeMap>
    with TickerProviderStateMixin {
  /// keeps the last MapPosition, changes on user input like zoom or move
  MapPosition _mapPosition;

  /// a [MapController] instnace
  MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _mapController.onReady.then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final TileLayerOptions tileLayerOptions = TileLayerOptions(
      urlTemplate: _getTemplateUrl(),
      subdomains: ['a', 'b', 'c'],
      backgroundColor: Theme.of(context).backgroundColor,
    );

    final MapOptions options = MapOptions(
        zoom: 5,
        minZoom: 2,
        maxZoom: 17,
        center: _getCenter(),
        onPositionChanged: _handleOnPositionChanged,
        plugins: [MapCreditsPlugin()]);

    return FlutterMap(
      options: options,
      mapController: _mapController,
      layers: [
        tileLayerOptions,
        MarkerLayerOptions(
          markers: _buildMarkers(
            widget.data.where((e) => e.magnitude > 1.5).toList(),
            _mapPosition,
          ),
        ),
        MapCreditsOption(
          text: getCreditsByMapStyle(
            getMapStyleByString(
              quakeSharedPreferences.getValue<String>(
                key: QuakeSharedPreferencesKey.mapTilesProvider,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Get saved template and get the associated URL
  String _getTemplateUrl() {
    String rawTemplateEnumString = quakeSharedPreferences.getValue<String>(
      key: QuakeSharedPreferencesKey.mapTilesProvider,
    );

    return getUrlByMapStyle(getMapStyleByString(rawTemplateEnumString));
  }

  /// returns a [LatLng] containing user's location
  LatLng _getCenter() {
    double latitude = quakeSharedPreferences.getValue<double>(
      key: QuakeSharedPreferencesKey.latitude,
    );

    double longitude = quakeSharedPreferences.getValue<double>(
      key: QuakeSharedPreferencesKey.longitude,
    );

    if (latitude == null || longitude == null) return null;

    LatLng coord = LatLng(latitude, longitude);

    return coord;
  }

  /// returns a [LatLng] containing earthquake location
  LatLng _getPosition(Earthquake earthquake) {
    return LatLng(earthquake.latitude, earthquake.longitude);
  }

  /// builds a single Marker
  Marker _buildMarker(Earthquake earthquake) {
    return Marker(
      point: _getPosition(earthquake),
      builder: (context) => GestureDetector(
            onTap: () => startDetailPage(context, earthquake),
            child: CustomPaint(
              painter: LocationMarkerPainter(
                text: earthquake.magnitude.toString(),
                color: Color.lerp(
                  Colors.green,
                  Colors.red,
                  earthquake.magnitude / 10,
                ),
              ),
            ),
          ),
    );
  }

  /// builds a cluster marker
  Marker _buildClusterMarker(Cluster cluster) {
    LatLng markerPosition = LatLng(cluster.location[0], cluster.location[1]);
    return Marker(
      point: markerPosition,
      builder: (_) => GestureDetector(
            onTap: () {
              _animatedMapMove(
                markerPosition,
                _mapController.zoom + 1.5,
              );
            },
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                cluster.instances.length.toString(),
              ),
            ),
          ),
    );
  }

  /// update _mapPosition on user interaction
  void _handleOnPositionChanged(MapPosition position, bool _) {
    // hacky, try catch used to prevent error "setState() or markNeedsBuild() called during build"
    try {
      setState(() {
        _mapPosition = position;
      });
    } catch (_) {}
  }

  // https://github.com/johnpryan/flutter_map/issues/201#issuecomment-463157542
  List<Marker> _buildMarkers(List<Earthquake> data, MapPosition position) {
    if (position == null || !position.bounds.isValid) {
      return [];
    }

    // Lookup Table
    final eventMap =
        data.fold<Map<String, Earthquake>>(Map(), (list, earthquake) {
      if (position.bounds.contains(_getPosition(earthquake))) {
        list[earthquake.eventID.toString()] = earthquake;
      }
      return list;
    });

    if (eventMap.isEmpty) return [];

    // kmeans instances
    List<Instance> instances = eventMap.values.map((earthquake) {
      return Instance(
        [earthquake.latitude, earthquake.longitude],
        id: earthquake.eventID.toString(),
      );
    }).toList();

    // max 10 marker shown
    List<Cluster> clusters = initialClusters(9, instances, seed: 0);
    kmeans(clusters: clusters, instances: instances);

    List<Marker> markers = clusters
        .map<Marker>((cluster) {
          if (cluster.instances.length == 0) return null;
          if (cluster.instances.length == 1) // marker
            return _buildMarker(eventMap[cluster.instances[0].id]);
          else
            return _buildClusterMarker(cluster);
        })
        .where((m) => m != null)
        .toList();

    return markers;
  }

  // https://github.com/johnpryan/flutter_map/blob/master/example/lib/pages/animated_map_controller.dart
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      // Note that the mapController.move doesn't seem to like the zoom animation. This may be a bug in flutter_map.
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}

/// CustomPainter used for the Marker Widget
class LocationMarkerPainter extends CustomPainter {
  final double width;
  final double height;
  final double radius;

  final Color color;

  final String text;

  LocationMarkerPainter({
    this.width: 40,
    this.height: 30,
    this.radius: 8,
    this.color: Colors.red,
    @required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        Radius.circular(radius),
      ),
      paint,
    );

    final style = ParagraphStyle(textAlign: TextAlign.center, maxLines: 1);
    final textStyle = TextStyle(color: Colors.white, fontSize: 20);
    final builder = ParagraphBuilder(style)
      ..pushStyle(textStyle)
      ..addText(text);
    final paragraph = builder.build()
      ..layout(ParagraphConstraints(width: width));
    canvas.drawParagraph(paragraph,
        Offset((width - paragraph.width) / 2, (height - paragraph.height) / 2));

    Path trianglePath = Path();

    double marginLeft = radius - radius * .5;
    double marginTop = height - radius / 8;
    trianglePath.moveTo(marginLeft, marginTop);

    trianglePath.lineTo(width / 2, height + height * .5);
    trianglePath.lineTo(marginLeft + width - radius, marginTop);
    trianglePath.lineTo(marginLeft, marginTop);
    trianglePath.close();

    canvas.drawPath(trianglePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MapCreditsOption extends LayerOptions {
  final String text;

  MapCreditsOption({@required this.text});
}

class MapCreditsPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is MapCreditsOption) {
      return Builder(
        builder: (context) => Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Theme.of(context).canvasColor,
                padding: EdgeInsets.all(4),
                child: Text(options.text ?? ''),
              ),
            ),
      );
    }
    throw UnknownOptionsException;
  }

  @override
  bool supportsLayer(LayerOptions options) => options is MapCreditsOption;
}

class UnknownOptionsException implements Exception {}
