import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

class OpenStreetMapNominatim {
  final String _baseUrl = "nominatim.openstreetmap.org";

  Client client;

  OpenStreetMapNominatim({Client newClient}) {
    client = newClient == null ? Client() : newClient;
  }

  Future<Map> reverseGeo({
    @required double latitude,
    @required double longitude,
    String language,
  }) async {
    final String methodName = "/reverse";
    return await _getData(methodName, {
      "format": "json",
      "lat": latitude.toString(),
      "lon": longitude.toString(),
      "accept-language": language ?? "en"
    });
  }

  Future<Map> _getData(String endPoint, Map<String, String> options) async {
    Response rawResponse = await client.get(Uri.https(
      _baseUrl,
      endPoint,
      options
    ));
    String body = rawResponse.body;
    return json.decode(body);
  }
}
