import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart';

import 'package:quake/src/api/exceptions.dart';
import 'package:quake/src/api/fsdnews_common.dart';

class _MockedClient extends Mock implements Client {}

void main() {
  FSDNewsOptions _circleOptions;
  FSDNewsOptions _bBoxOptions;

  FSDNews _fsdNews = FSDNews(Uri(
    scheme: 'http',
    host: 'webservices.ingv.it',
    path: 'fdsnws/event/1/query',
  ));

  setUp(() {
    _circleOptions = FSDNewsOptions.fromCircleConstraints(
      start: DateTime(2019, 7, 15, 17, 00, 00),
      end: DateTime(2019, 7, 21, 00, 00, 00),
      latitude: 41.89,
      longitude: 12.49,
      minRadius: 0,
      maxRadius: 10,
      minDepth: 0,
      maxDepth: 100,
      minMagnitude: 0,
      maxMagnitude: 12,
      limit: 2,
    );

    _bBoxOptions = FSDNewsOptions.fromBoxConstraints(
      start: DateTime(2019, 7, 15, 17, 00, 00),
      end: DateTime(2019, 7, 21, 00, 00, 00),
      minLatitude: -90,
      maxLatitude: 90,
      minLongitude: -90,
      maxLongitude: 90,
      minDepth: 0,
      maxDepth: 100,
      minMagnitude: 0,
      maxMagnitude: 12,
      limit: 2,
    );
  });

  group('FSDNewsOptions', () {
    test(
        'isValid should return true on a instance created '
        'with fromCircleConstraints even if some parameters '
        'are missing', () {
      expect(_circleOptions.isValid(), isTrue);
    });

    test(
        'isValid should return true on a instance created '
        'with fromBoxConstraints even if some parameters '
        'are missing', () {
      expect(_bBoxOptions.isValid(), isTrue);
    });

    test(
        'fromCircleConstraints: isValid should return false if '
        'a required parameter is null', () {
      _circleOptions.latitude = null;
      expect(_circleOptions.isValid(), isFalse);
    });

    test(
        'fromBoxConstraints: isValid should return false if '
        'a required parameter is null', () {
      _bBoxOptions.minLatitude = null;
      expect(_bBoxOptions.isValid(), isFalse);
    });

    test(
        'Try to build a query map of _circleOptions and '
        'check that it doesn\'t contain bounding box fields', () {
      expect(_circleOptions.toQueryMap().containsKey("minlatitude"), isFalse);
      expect(_circleOptions.toQueryMap().containsKey("minlongitude"), isFalse);
      expect(_circleOptions.toQueryMap().containsKey("maxlatitude"), isFalse);
      expect(_circleOptions.toQueryMap().containsKey("maxlongitude"), isFalse);
    });

    test(
        'Try to build a query map of _bBoxOptions and '
        'check that it doesn\'t contain circle box fields', () {
      expect(_bBoxOptions.toQueryMap().containsKey("latitude"), isFalse);
      expect(_bBoxOptions.toQueryMap().containsKey("longitude"), isFalse);
      expect(_bBoxOptions.toQueryMap().containsKey("minradius"), isFalse);
      expect(_bBoxOptions.toQueryMap().containsKey("maxradius"), isFalse);
    });
  });

  group('FSDNews', () {
    FSDNews _mockedFsdNews;
    final _MockedClient _client = _MockedClient();

    const String _url =
        "http://webservices.ingv.it/fdsnws/event/1/query?starttime=2019-07-15T17%3A00%3A00&endtime=2019-07-21T00%3A00%3A00&mindepth=0.00&maxdepth=100.00&minmagnitude=0.00&maxmagnitude=12.00&limit=2&offset=1&format=xml&latitude=41.89&longitude=12.49&minradius=0.00&maxradius=10.00";

    final Matcher throwsNoResponse =
        throwsA(TypeMatcher<NoResponseException>());
    final Matcher throwsNoContent = throwsA(TypeMatcher<NoContentException>());
    final Matcher throwsBadResponse =
        throwsA(TypeMatcher<BadResponseException>());
    final Matcher throwsTimeoutException =
        throwsA(TypeMatcher<TimeoutException>());

    setUp(() {
      _mockedFsdNews = FSDNews(
        Uri(
          scheme: 'http',
          host: 'webservices.ingv.it',
          path: 'fdsnws/event/1/query',
        ),
        client: _client,
      );
    });

    test('test fetchData from the internet', () async {
      expect(await _fsdNews.fetchData(options: _circleOptions), isList,
          reason:
              'This could fail at any time due to lack of internet connection');
      expect(await _fsdNews.fetchData(options: _bBoxOptions), isList,
          reason:
              'This could fail at any time due to lack of internet connection');
    });

    test('fetchData should work correctly with a correct response', () async {
      when(_client.get(any)).thenAnswer(
        (_) async =>
            Response((await File('test/response.xml').readAsString()), 200),
      );

      expect(await _mockedFsdNews.fetchData(options: _circleOptions), isList);
    });

    test('fetchData should throw NoResponseException on null response',
        () async {
      when(_client.get(any)).thenAnswer((_) async => null);

      expect(
        () async => await _mockedFsdNews.fetchData(options: _circleOptions),
        throwsNoResponse,
      );
    });

    test('fetchData should throw NoContentException on 204 status code',
        () async {
      when(_client.get(any))
          .thenAnswer((_) async => Response("https://http.cat/204", 204));

      expect(
        () async => await _mockedFsdNews.fetchData(options: _circleOptions),
        throwsNoContent,
      );
    });

    test(
        'fetchData should throw BadResponseException on 400 status code'
        ' and malformed data', () async {
      when(_client.get(any))
          .thenAnswer((_) async => Response("https://http.cat/400", 400));

      expect(
        () async => await _mockedFsdNews.fetchData(options: _circleOptions),
        throwsBadResponse,
      );

      when(_client.get(any))
          .thenAnswer((_) async => Response("<q:quakeml></q:quakeml>", 400));

      expect(
        () async => await _mockedFsdNews.fetchData(options: _circleOptions),
        throwsBadResponse,
      );
    });

    test('fetchData should throw TimeoutException after 20 seconds of waiting',
        () async {
      when(_client.get(any))
          .thenAnswer((_) async => await Future.delayed(Duration(seconds: 21)));

      expect(
        () async => await _mockedFsdNews.fetchData(options: _circleOptions),
        throwsTimeoutException,
      );
    });
  });
}
