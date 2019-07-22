import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import 'package:http/http.dart';
import 'package:xml2json/xml2json.dart';

import 'package:quake/src/api/exceptions.dart';
import 'package:quake/src/api/model/earthquake.dart';

/// This enum indicates the method to get earthquakes for a zone.
///
/// There are two ways to indicate a zone where to get earthquakes:
/// - box: needs box area constraints (minlat, maxlat, minlon, maxlon)
/// - circle: needs latitude, longitude and min/max radius of the
///   circle of the zone
enum _GeographicConstraintsType { box, circle }

/// Since the api is common for every earthquake website,
/// the only thing that's going to change is the API url
/// of the webserver stored into [_apiUrl].
///
/// Specification of FSDNews: http://www.fdsn.org/webservices
class FSDNews {
  /// Instance of [Client], it can be used to pass mocked clients
  /// using the constructor.
  final Client _httpClient;

  /// The classes that are going to inherit this class must call
  /// the super constructor with the custom api url.
  ///
  /// Additional query parameters will be ignored.
  final Uri _apiUrl;

  /// This constructor must be called by subclasses in order
  /// t set a custom [_apiUrl].
  ///
  /// This class can be used directly, but it's better to use
  /// subclasses for every webserver.
  FSDNews(
    this._apiUrl, {
    Client client,
  }) : _httpClient = client ?? Client();

  /// This function takes care to ask the server for an xml of the earthquakes
  /// that match the options given with [options].
  Future<List<Earthquake>> fetchData({@required FSDNewsOptions options}) async {
    Response _response = await _httpClient
        .get(
          Uri(
            scheme: _apiUrl.scheme.isEmpty ? 'http' : _apiUrl.scheme,
            host: _apiUrl.host,
            path: _apiUrl.path.isEmpty ? 'fdsnws/event/1/query' : _apiUrl.path,
            queryParameters: options.toQueryMap(),
          ),
        )
        .timeout(Duration(seconds: 20));

    if (_response == null) throw NoResponseException();

    if (_response.statusCode == 204) throw NoContentException();

    if (_response.statusCode == 400) throw BadResponseException();

    final Map _responseAsJson =
        await compute(_convertXmlToJson, _response.body);

    if (_responseAsJson.isEmpty ||
        _responseAsJson["q:quakeml"] == null ||
        _responseAsJson["q:quakeml"]["eventParameters"] == null)
      throw BadResponseException();

    return (_responseAsJson["q:quakeml"]["eventParameters"]["event"] as List)
        .map((_event) => Earthquake.fromJson(_event))
        .toList();
  }

  /// This function will parse the passed [xml] to a json and will
  /// be run in a separate isolate by the compute call
  /// in [fetchData()]
  static Map _convertXmlToJson(String xml) {
    final Xml2Json _xml2Json = Xml2Json()..parse(xml);
    return json.decode(_xml2Json.toParker());
  }
}

/// Specification of FSDNewsEvent 1.2 from:
/// http://www.fdsn.org/webservices/fdsnws-event-1.2.pdf
///
/// This is NOT a complete implementation of the
/// specification, some parameters are missing because
/// they're never going to be used in the application.
class FSDNewsOptions {
  /// See [_GeographicConstraintsType]
  final _GeographicConstraintsType __geographicConstraintsType;

  /// REQUIRED: Limit to events on or after the specified
  /// start time.
  ///
  /// Parameter name: `starttime` or `start`
  /// Defaults to `[Any]`.
  /// Time should be UTC.
  final DateTime start;

  /// REQUIRED: Limit to events on or before the specified
  /// end time.
  ///
  /// Parameter name: `endtime` or `end`
  /// Defaults to `[Any]`.
  /// Time should be UTC.
  final DateTime end;

  /// REQUIRED(if box): Limit to events with a latitude larger
  /// than or equal to the specified minimum.
  ///
  /// Parameter name: `minlatitude` or `minlat`
  /// Defaults to `-90`
  /// Unit should be degrees and should be beetween -90 and 90
  double minLatitude;

  /// REQUIRED(if box): Limit to events with a latitude smaller
  /// than or equal to the specified maximum.
  ///
  /// Parameter name: `maxlatitude` or `maxlat`
  /// Defaults to `90`
  /// Unit should be degrees and should be beetween -90 and 90
  double maxLatitude;

  /// REQUIRED(if box): Limit to events with a longitude larger
  /// than or equal to the specified minimum.
  ///
  /// Parameter name: `minlongitude` or `minlon`
  /// Defaults to `-180`
  /// Unit should be degrees and should be beetween -180 and 180
  double minLongitude;

  /// REQUIRED(if box): Limit to events with a longitude smaller
  /// than or equal to the specified maximum.
  ///
  /// Parameter name: `maxlongitude` or `maxlon`
  /// Defaults to `180`
  /// Unit should be degrees and should be beetween -180 and 180
  double maxLongitude;

  /// REQUIRED(if circle): Specify the latitude to be used for
  /// a radius search.
  ///
  /// Parameter name: `latitude` or `lat`
  /// Defaults to `0`
  /// Unit should be degrees and should be beetween -90 and 90
  double latitude;

  /// REQUIRED(if circle): Specify the longitude to be used for
  /// a radius search.
  ///
  /// Parameter name: `longitude` or `lon`
  /// Defaults to `0`
  /// Unit should be degrees and should be beetween -180 and 180
  double longitude;

  /// REQUIRED(if circle): Limit to events within the specified
  /// minimum number of degrees from the geographic point defined
  /// by the latitude and longitude parameters.
  ///
  /// Parameter name: `minradius`
  /// Defaults to `0`
  /// Unit should be degrees and should be beetween 0 and 180
  double minRadius;

  /// REQUIRED(if circle): Limit to events within the specified
  /// maximum number of degrees from the geographic point defined
  /// by the latitude and longitude parameters.
  ///
  /// Parameter name: `maxradius`
  /// Defaults to `0`
  /// Unit should be degrees and should be beetween 0 and 180
  double maxRadius;

  /// REQUIRED: Limit to events with depth more than the specified
  /// minimum.
  ///
  /// Parameter name: `mindepth`
  /// Defaults to `[Any]`
  /// Unit should be kilometers.
  final double minDepth;

  /// REQUIRED: Limit to events with depth less than the specified
  /// maximum.
  ///
  /// Parameter name: `maxdepth`
  /// Defaults to `[Any]`
  /// Unit should be kilometers.
  final double maxDepth;

  /// REQUIRED: Limit to events with a magnitude larger than the
  /// specified minimum.
  ///
  /// Parameter name: `minmagnitude` or `minmag`
  /// Defauts to `[Any]`
  /// Unit is defined by magType, Richter by default
  final double minMagnitude;

  /// REQUIRED: Limit to events with a magnitude smaller than the
  /// specified maximum.
  ///
  /// Parameter name: `maxmagnitude` or `maxmag`
  /// Defauts to `[Any]`
  /// Unit is defined by magtype, Richter by default
  final double maxMagnitude;

  /// Limit the results to the specified number of events.
  ///
  /// Parameter name: `limit`
  /// Defaults to `[Any]`
  /// Must be greater or equal than 1
  final int limit;

  /// Return results starting at the event count specified,
  /// starting at 1.
  ///
  /// Parameter name: `limit`
  /// Defaults to `[Any]`
  /// Must be greater or equal than 1
  final int offset;

  /// Specify format of result, either xml (default) or text
  /// (defined below). If this parameter is not specified the
  /// service must return QuakeML.
  ///
  /// Parameter name: `format`
  /// Defaults to `xml`
  static const String _format = "xml";

  /// Constructor that must be used to create a request with
  /// bounding box geographical constraints
  FSDNewsOptions.fromBoxConstraints({
    @required this.start,
    @required this.end,
    @required this.minDepth,
    @required this.maxDepth,
    @required this.minMagnitude,
    @required this.maxMagnitude,
    @required this.minLatitude,
    @required this.maxLatitude,
    @required this.minLongitude,
    @required this.maxLongitude,
    this.limit = 100,
    this.offset = 1,
  })  : __geographicConstraintsType = _GeographicConstraintsType.box,
        assert(start.isBefore(end));

  /// Constructor that must be used to create a request with
  /// circle geographical constraints
  FSDNewsOptions.fromCircleConstraints({
    @required this.start,
    @required this.end,
    @required this.minDepth,
    @required this.maxDepth,
    @required this.minMagnitude,
    @required this.maxMagnitude,
    @required this.latitude,
    @required this.longitude,
    @required this.minRadius,
    @required this.maxRadius,
    this.limit = 100,
    this.offset = 1,
  })  : __geographicConstraintsType = _GeographicConstraintsType.circle,
        assert(start.isBefore(end));

  /// Checks if class contains every field necessary to create a valid
  /// request.
  ///
  /// Returns true if one field is null
  bool isValid() {
    final List _fields = [
      this.start,
      this.end,
      this.minMagnitude,
      this.maxMagnitude,
      this.minDepth,
      this.maxDepth,
    ];

    return __geographicConstraintsType == _GeographicConstraintsType.box
        ? [
            ..._fields,
            this.minLatitude,
            this.maxLatitude,
            this.minLongitude,
            this.maxLongitude,
          ].where((var field) => field == null).isEmpty
        : [
            ..._fields,
            this.latitude,
            this.longitude,
            this.minRadius,
            this.maxRadius,
          ].where((var field) => field == null).isEmpty;
  }

  Map<String, dynamic> toQueryMap() {
    if (!isValid()) throw OptionsNotValidException();

    Map<String, dynamic> _queryParameters = {
      "starttime": __toStandardDate(start),
      "endtime": __toStandardDate(end),
      "mindepth": __round(minDepth),
      "maxdepth": __round(maxDepth),
      "minmagnitude": __round(minMagnitude),
      "maxmagnitude": __round(maxMagnitude),
      "limit": limit.toString(),
      "offset": offset.toString(),
      "format": _format,
    };

    if (__geographicConstraintsType == _GeographicConstraintsType.box)
      _queryParameters.addAll({
        "minlatitude": __round(minLatitude),
        "maxlatitude": __round(maxLatitude),
        "minlongitude": __round(minLongitude),
        "maxlongitude": __round(maxLongitude),
      });
    else
      _queryParameters.addAll({
        "latitude": __round(latitude),
        "longitude": __round(longitude),
        "minradius": __round(minRadius),
        "maxradius": __round(maxRadius),
      });

    return _queryParameters;
  }

  /// Remove milliseconds from string
  String __toStandardDate(DateTime date) =>
      date.toIso8601String().split(".")[0];

  /// Round the double to 2 decimal digits and convert to
  /// String to make it compatible with the API
  String __round(double n) => n.toStringAsFixed(2);
}
