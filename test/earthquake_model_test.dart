import 'package:flutter_test/flutter_test.dart';
import 'package:quake/src/model/earthquake.dart';

void main() {
  String test_string =
      "21225591|2018-12-16T05:12:38.400000|42.6073|13.3263|13.2|SURVEY-INGV||||ML|2.0|--|4 km SE Amatrice (RI)";
  Map test_map = {
    "eventID": 21225591,
    "time": DateTime.parse("2018-12-16 05:12:38.400"),
    "latitude": 42.6073,
    "longitude": 13.3263,
    "depth": 13.2,
    "author": "SURVEY-INGV",
    "catalog": "",
    "contributor": "",
    "contributorID": "",
    "magnitudeType": "ML",
    "magnitude": 2.0,
    "magnitudeAuthor": "--",
    "eventLocationName": "4 km SE Amatrice (RI)",
  };

  test('Check if Earthquake fromText constructor works correctly', () {
    Earthquake earthquake = Earthquake.fromText(test_string);
    expect(earthquake.toMap(), test_map);
  });

  test('Check if Earthquake fromMap constructor works correctly', () {
    Earthquake earthquake = Earthquake.fromMap(test_map);

    expect(earthquake.eventID, 21225591);
    expect(earthquake.time, DateTime.parse("2018-12-16 05:12:38.400"));
    expect(earthquake.latitude, 42.6073);
    expect(earthquake.longitude, 13.3263);
    expect(earthquake.depth, 13.2);
    expect(earthquake.author, "SURVEY-INGV");
    expect(earthquake.catalog, "");
    expect(earthquake.contributor, "");
    expect(earthquake.contributorID, "");
    expect(earthquake.magnitudeType, "ML");
    expect(earthquake.magnitude, 2.0);
    expect(earthquake.magnitudeAuthor, "--");
    expect(earthquake.eventLocationName, "4 km SE Amatrice (RI)");
  });
}
