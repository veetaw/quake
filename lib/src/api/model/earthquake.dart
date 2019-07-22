import 'package:quake/src/api/model/event_type.dart';

class Earthquake {
  /// Contains the type (cause) of the event according to the
  /// quakeml specification.
  ///
  /// position in json: `json["type"]`
  EventType type;

  /// Contains the location name of where the earthquake happened.
  ///
  /// position in json: `json["description"]["text"]`
  String eventName;

  /// The agency that registered the earthquake.
  ///
  /// position in json: `json["creationInfo"]["author"]`
  String author;

  /// The time when the earthquake was added to the API, usually
  /// 15 min after the first registration
  ///
  /// position in json: `json["creationInfo"]["creationTime"]`
  DateTime creationTime;

  /// This variable will contain the geographical coordinates of
  /// the earthquake
  ///
  /// position in json (latitude): `json["origin"]["latitude"]["value"]`
  /// position in json (longitude): `json["origin"]["longitude"]["value"]`
  _Coordinates coordinates;

  /// Contains the depth of the earthquake
  ///
  /// position in json: `json["origin"]["depth"]["value"]`
  double depth;

  /// Contains the uncertainity of the depth measuration
  ///
  /// position in json: `json["origin"]["depth"]["uncertainity"]`
  double depthUncertainity;

  /// Contains the magnitude of the earthquake.
  ///
  /// position in json: `json["magnitude"]["mag"]["value"]`
  double magnitude;

  /// Contains the uncertainity of the magnitude measuration
  ///
  /// position in json: `json["magnitude"]["mag"]["uncertainity"]`
  double magnitudeUncertainity;

  /// The number of the stations that detected the earthquake
  ///
  /// position in json: `json["magnitude"]["stationCount"]`
  int stationCount;

  /// The time when the earthquake happened
  ///
  /// position in json: `json["origin"]["time"]["value"]`
  DateTime time;

  Earthquake.fromJson(Map json)
      : type = eventTypeFromText(json["type"]),
        eventName = json["description"]["text"],
        author = json["creationInfo"]["author"],
        creationTime = DateTime.parse(json["creationInfo"]["creationTime"]),
        coordinates = _Coordinates(
          double.parse(json["origin"]["latitude"]["value"]),
          double.parse(json["origin"]["longitude"]["value"]),
        ),
        depth = double.parse(json["origin"]["depth"]["value"]),
        depthUncertainity =
            double.parse(json["origin"]["depth"]["uncertainity"] ?? "0"),
        magnitude = double.parse(json["magnitude"]["mag"]["value"]),
        magnitudeUncertainity =
            double.parse(json["magnitude"]["mag"]["uncertainity"] ?? "0"),
        stationCount = int.parse(json["magnitude"]["stationCount"] ?? "0"),
        time = DateTime.parse(json["origin"]["time"]["value"]);
}

class _Coordinates {
  final double latitude;
  final double longitude;

  const _Coordinates(this.latitude, this.longitude);
}
