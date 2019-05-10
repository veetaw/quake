import 'dart:async';

import 'package:http/http.dart';
import 'package:quake/src/model/earthquake.dart';

/// Supports every FDSN WS-EVENT
///
/// The API defaults to IngvAPI
class FsdnAPI {
  final String url;
  final String urlScheme;
  final String urlPath;

  static const int _kDaysToSubtract = 5;

  static const String _kMinVersion = "100";
  static const String _kOrderBy = "time";
  static const String _kFormat = "text";

  Client client;

  /// constructor
  ///
  /// client is an optional parameter, useful for testing
  FsdnAPI({
    this.client,
    this.urlScheme: "http",
    this.url: "webservices.ingv.it",
    this.urlPath: "fdsnws/event/1/query",
  }) {
    if (client == null) {
      client = Client();
    }
  }

  /// get a future of list of earthquake (s)
  ///
  /// There are optional parameters like [startTime], [endTime], [minMagnitude] etc..
  Future<List<Earthquake>> getData({
    DateTime startTime,
    DateTime endTime,
    num minMagnitude,
    num maxMagnitude,
    num minDepth,
    num maxDepth,
    num minLatitude,
    num maxLatitude,
    num minLongitude,
    num maxLongitude,
    num limit: 100,
  }) async {
    Response response = await client.get(
      Uri(
        scheme: urlScheme,
        host: url,
        path: urlPath,
        queryParameters: {
          "starttime": (startTime != null
                  ? startTime
                  : DateTime.now().subtract(Duration(days: _kDaysToSubtract)))
              .toIso8601String(),
          "endtime":
              (endTime != null ? endTime : DateTime.now()).toIso8601String(),
          "minmag": (minMagnitude ?? -1.0).toString(),
          "maxmag": (maxMagnitude ?? 10.0).toString(),
          "mindepth": (minDepth ?? -10).toString(),
          "maxdepth": (maxDepth ?? 1000).toString(),
          "minlat": (minLatitude ?? -90).toString(),
          "maxlat": (maxLatitude ?? 90).toString(),
          "minlon": (minLongitude ?? -180).toString(),
          "maxlon": (maxLongitude ?? 180).toString(),
          "minversion": _kMinVersion,
          "orderby": _kOrderBy,
          "format": _kFormat,
          "limit": limit.toString(),
        },
      ),
    );

    /// no response, probably there's no connection
    if (response == null) throw NoResponseException;

    /// server returned 204 no content because there are no earthquakes to return
    if (response.statusCode == 204) throw NoContentException;

    /// response status is not ok
    if (response.statusCode != 200)
      throw BadResponseException(response.statusCode);

    var data = response.body.split('\n');

    /// remove first and null/empty elements from list
    data.removeAt(0);
    data.removeWhere((earthquake) => earthquake.isEmpty || earthquake == null);

    /// list empty after removing header
    if (data.length == 0) throw NoEarthquakesException;

    try {
      return data.map((earthquake) => Earthquake.fromText(earthquake)).toList();
    } catch (_) {
      /// something bad happened during parsing text
      throw MalformedResponseException;
    }
  }

  Future<Earthquake> fetchEarthquakeById(String eventID) async {
    Response response = await client.get(
      Uri(
        scheme: urlScheme,
        host: url,
        path: urlPath,
        queryParameters: {
          "eventId": eventID,
          "format": _kFormat,
        },
      ),
    );

    /// no response, probably there's no connection
    if (response == null) throw NoResponseException;

    /// server returned 204 no content because there are no earthquakes to return
    if (response.statusCode == 204) throw NoContentException;

    /// response status is not ok
    if (response.statusCode != 200)
      throw BadResponseException(response.statusCode);

    var data = response.body.split('\n');

    /// remove first and null/empty elements from list
    data.removeAt(0);
    data.removeWhere((earthquake) => earthquake.isEmpty || earthquake == null);

    /// list empty after removing header
    if (data.length == 0) throw NoEarthquakesException;

    try {
      return Earthquake.fromText(data.first);
    } catch (_) {
      /// something bad happened during parsing text
      throw MalformedResponseException;
    }
  }

  //// must be called in order to free client's memory
  void dispose() {
    client.close();
  }
}

class EmscCsemAPI extends FsdnAPI {
  EmscCsemAPI()
      : super(
          url: "www.seismicportal.eu",
          urlPath: "fdsnws/event/1/query",
        );
}

class IngvAPI extends FsdnAPI {}

/// Server did not respond, maybe because it's down or because the connection of
/// the phone dropped
class NoResponseException implements Exception {}

/// Server answered with 204 no content
class NoContentException implements Exception {}

/// There are no earthquakes to show
class NoEarthquakesException implements Exception {}

/// Bad response from the server
class MalformedResponseException implements Exception {}

/// Unknown response code from Server.
class BadResponseException implements Exception {
  final int statusCode;

  BadResponseException(this.statusCode);
}
