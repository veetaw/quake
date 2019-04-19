import 'package:meta/meta.dart';

/// Earthquake model class
///
/// The data from the api is returned in this way:
/// #EventID|Time|Latitude|Longitude|Depth/Km|Author|Catalog|Contributor|ContributorID|MagType|Magnitude|MagAuthor|EventLocationName
/// so to parse it from a raw string it's needed to split the string by '|'
///
/// Indexes and what they represent after split:
/// 0 => EventID
/// 1 => Time
/// 2 => Latitude
/// 3 => Longitude
/// 4 => Depth/Km
/// 5 => Author
/// 6 => Catalog
/// 7 => Contributor
/// 8 => ContributorID
/// 9 => MagType
/// 10 => Magnitude
/// 11 => MagAuthor
/// 12 => EventLocationName
@immutable
class Earthquake {
  final int eventID;
  final DateTime time;
  final num latitude;
  final num longitude;
  final num depth;
  final String author;
  final String catalog;
  final String contributor;
  final String contributorID;
  final String magnitudeType;
  final num magnitude;
  final String magnitudeAuthor;
  final String eventLocationName;

  /// Standard constructor
  Earthquake({
    @required this.eventID,
    @required this.time,
    @required this.latitude,
    @required this.longitude,
    @required this.depth,
    this.author,
    this.catalog,
    this.contributor,
    this.contributorID,
    this.magnitudeType,
    @required this.magnitude,
    this.magnitudeAuthor,
    @required this.eventLocationName,
  });

  /// Named constructor that must be used with a valid string response from the API
  Earthquake.fromText(String rawText)
      : assert(rawText.split('|')?.length == 13),
        this.eventID = int.parse(rawText.split('|')[0] ?? null),
        this.time = DateTime.parse(rawText.split('|')[1]),
        this.latitude = num.parse(rawText.split('|')[2] ?? 0.0),
        this.longitude = num.parse(rawText.split('|')[3] ?? 0.0),
        this.depth = num.parse(rawText.split('|')[4] ?? 0.0),
        this.author = rawText.split('|')[5] ?? "",
        this.catalog = rawText.split('|')[6] ?? "",
        this.contributor = rawText.split('|')[7] ?? "",
        this.contributorID = rawText.split('|')[8] ?? "",
        this.magnitudeType = rawText.split('|')[9] ?? "",
        this.magnitude = num.parse(rawText.split('|')[10] ?? 0.0),
        this.magnitudeAuthor = rawText.split('|')[11] ?? "",
        this.eventLocationName = rawText.split('|')[12] ?? "";

  /// This constructor is here because of future implementation of caching
  Earthquake.fromMap(Map map)
      : assert(map != null),
        this.eventID = map["eventID"] ?? 0,
        this.time = DateTime.fromMillisecondsSinceEpoch(map["time"] ?? null),
        this.latitude = map["latitude"] ?? 0.0,
        this.longitude = map["longitude"] ?? 0.0,
        this.depth = map["depth"] ?? 0.0,
        this.author = map["author"] ?? "",
        this.catalog = map["catalog"] ?? "",
        this.contributor = map["contributor"] ?? "",
        this.contributorID = map["contributorID"] ?? "",
        this.magnitudeType = map["magnitudeType"] ?? "",
        this.magnitude = map["magnitude"] ?? 0.0,
        this.magnitudeAuthor = map["magnitudeAuthor"] ?? "",
        this.eventLocationName = map["eventLocationName"] ?? "";

  /// A shrinked version if [toMap()]
  Map<String, dynamic> toDBMap() {
    return {
      "eventID": eventID,
      "time": time.millisecondsSinceEpoch,
      "latitude": latitude,
      "longitude": longitude,
      "depth": depth,
      "magnitude": magnitude,
      "eventLocationName": eventLocationName,
    };
  }

  Map toMap() {
    return {
      "eventID": eventID,
      "time": time,
      "latitude": latitude,
      "longitude": longitude,
      "depth": depth,
      "author": author,
      "catalog": catalog,
      "contributor": contributor,
      "contributorID": contributorID,
      "magnitudeType": magnitudeType,
      "magnitude": magnitude,
      "magnitudeAuthor": magnitudeAuthor,
      "eventLocationName": eventLocationName,
    };
  }
}
