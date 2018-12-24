import 'dart:async';

import 'package:http/http.dart';
import 'package:quake/src/model/earthquake.dart';

/// Wrapper over ingv's text API
class IngvAPI {
  static const String _kScheme = "http";
  static const String _kUrl = "webservices.ingv.it";
  static const String _kPath = "fdsnws/event/1/query";

  static const int _kDaysToSubtract = 5;

  static const String _kMinVersion = "100";
  static const String _kOrderBy = "time-asc";
  static const String _kFormat = "text";
  static const String _kLimit = "10000";

  Client client;

  /// constructor
  ///
  /// client is an optional parameter, useful for testing
  IngvAPI({this.client}) {
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
  }) async {
    Response response = await client.get(
      Uri(
        scheme: _kScheme,
        host: _kUrl,
        path: _kPath,
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
          "limit": _kLimit,
        },
      ),
    );

    /// no response, probably there's no connection
    if (response == null) throw Exception('no response');

    /// response status is not ok
    if (response.statusCode != 200) throw Exception('bad response');

    var data = response.body.split('\n');

    /// remove first and null/empty elements from list
    data.removeAt(0);
    data.removeWhere((earthquake) => earthquake.isEmpty || earthquake == null);

    /// list empty after removing header
    if (data.length == 0) throw Exception('no results');

    try {
      return data.map((earthquake) => Earthquake.fromText(earthquake)).toList();
    } catch (_) {
      /// something bad happened during parsing text
      throw Exception('parse exception');
    }
  }

  //// must be called in order to free client's memory
  void dispose() {
    client.close();
  }
}
