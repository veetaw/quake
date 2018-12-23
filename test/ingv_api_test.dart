import 'package:flutter_test/flutter_test.dart';
import 'package:quake/src/data/ingv_api.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group("Test API with mocked data", () {
    final String mockResponseString =
        "#EventID|Time|Latitude|Longitude|Depth/Km|Author|Catalog|Contributor|ContributorID|MagType|Magnitude|MagAuthor|EventLocationName\n21225591|2018-12-16T05:12:38.400000|42.6073|13.3263|13.2|SURVEY-INGV||||ML|2.0|--|4 km SE Amatrice (RI)";
    final Map mockedTestMap = {
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

    /// mocked client to simulate response from the API
    final MockClient client = MockClient();
    IngvAPI api;

    setUp(() {
      api = IngvAPI(client: client);
    });

    test("Test correct response", () async {
      when(client.get(any))
          .thenAnswer((_) async => http.Response(mockResponseString, 200));
      expect((await api.getData())[0].toMap(), mockedTestMap);
    });

    test("Test bad response (ieg 404 error)", () {
      when(client.get(any)).thenAnswer((_) async => http.Response("", 404));
      expect(() async => await api.getData(), throwsException);
    });

    test("Test empty response", () async {
      when(client.get(any)).thenAnswer((_) async => http.Response("", 200));
      expect(await api.getData(), isEmpty);
    });
  });

  test('Test API with real data', () async {
    IngvAPI api = IngvAPI();
    expect(await api.getData(), isNotNull);
  });
}
