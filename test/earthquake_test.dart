import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import 'package:quake/src/api/model/earthquake.dart';

main() {
  group('Earthquake', () {
    Map _jsonText;

    setUp(() async {
      try {
        _jsonText =
            json.decode(await File('test/earthquake.json').readAsString());
      } catch (_) {
        _jsonText =
            json.decode(await File('earthquake.json').readAsString());
      }
    });

    test('fromJson constructor should work correctly with valid data', () {
      Earthquake _earthquake = Earthquake.fromJson(_jsonText);

      expect(_earthquake, isNotNull);
      expect(_earthquake.type, isNotNull);
      expect(_earthquake.eventName, isNotNull);

      expect(_earthquake.coordinates.latitude, isNotNull);
      expect(_earthquake.coordinates.longitude, isNotNull);
    });

    test('fromJson should handle nullable fields', () {
      _jsonText["origin"]["depth"]["uncertainity"] = null;
      _jsonText["magnitude"]["mag"]["uncertainity"] = null;
      _jsonText["magnitude"]["stationCount"] = null;

      Earthquake _earthquake = Earthquake.fromJson(_jsonText);

      expect(_earthquake.depthUncertainity, isZero);
      expect(_earthquake.magnitudeUncertainity, isZero);
      expect(_earthquake.stationCount, isZero);
    });
  });
}
