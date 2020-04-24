import 'package:latlong/latlong.dart';

class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates(this.latitude, this.longitude);

  LatLng asLatLng() => LatLng(latitude ?? 0, longitude ?? 0);
}
