import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

Future<Map> getPopulationByCoordinates({
  @required double latitude,
  @required double longitude,
  double radiusKm = 20,
}) async {
  Response response = await get(Uri.http(
    "sedac.ciesin.columbia.edu",
    "/arcgis/rest/services/sedac/pesv3Broker/GPServer/pesv3Broker/execute",
    {
      "env:outSR": "",
      "returnZ": "false",
      "returnM": "false",
      "returnTrueCurves": "false",
      "f": "pjson",
      "Input_Data": {
        "polygon": [
          "buffer",
          [
            [latitude, longitude]
          ],
          radiusKm,
          "Kilometers"
        ],
        "statistics": ["SUM"],
        "variables": ["gpw-v4-population-count-rev10_2020"],
        "requestID": "quake-app"
      }.toString(),
    },
  ));

  return json.decode(response.body);
}
