import 'dart:async';

import 'package:quake/src/data/ingv_api.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:rxdart/rxdart.dart';

abstract class EarthquakesBlocBase {
  Observable<List<Earthquake>> get earthquakes;
}

class EarthquakesRepository {
  IngvAPI api = IngvAPI();

  Future<List<Earthquake>> fetchData() async => api.getData();
  Future<List<Earthquake>> fetchDataSearch(SearchOptions options) async =>
      api.getData(
        startTime: options.startTime,
        endTime: options.endTime,
        minMagnitude: options.minMagnitude,
        maxDepth: options.maxDepth,
        maxMagnitude: options.maxMagnitude,
        minDepth: options.minDepth,
        minLatitude: options.minLatitude,
        maxLatitude: options.maxLatitude,
        maxLongitude: options.maxLongitude,
        minLongitude: options.minLongitude,
      );
}

/// Singleton class that represents the bloc to fetch earthquakes
class EarthquakesBloc implements EarthquakesBlocBase {
  static EarthquakesBloc _instance = EarthquakesBloc._();
  EarthquakesBloc._();
  factory EarthquakesBloc() => _instance;

  final EarthquakesRepository _earthquakesRepository = EarthquakesRepository();
  final PublishSubject _stream = PublishSubject<List<Earthquake>>();

  List<Earthquake> _cache = List();

  Observable<List<Earthquake>> get earthquakes => _stream.stream;

  Future fetchData() async {
    if (_cache.isEmpty)
      _cache = await _earthquakesRepository.fetchData();
    else
      // HACK: if this micro delay is removed stream observer won't get anything
      await Future.delayed(Duration(microseconds: 1));

    _stream.sink.add(_cache);
  }

  void invalidateCacheAndFetch() {
    clearCache();

    fetchData();
  }

  void clearCache() {
    _cache = List();
  }

  // must be called by the subscriber in order to correctly free resources
  void dispose() {
    _earthquakesRepository.api.dispose();
    _stream.close();
  }
}

class EarthquakesSearchBloc implements EarthquakesBlocBase {
  static EarthquakesSearchBloc _instance = EarthquakesSearchBloc._();
  EarthquakesSearchBloc._();
  factory EarthquakesSearchBloc() => _instance;

  final EarthquakesRepository _earthquakesRepository = EarthquakesRepository();
  final PublishSubject _stream =
      PublishSubject<List<Earthquake>>();

  Observable<List<Earthquake>> get earthquakes => _stream.stream;

  Future search({SearchOptions options}) async {
    // no search "terms" (options) given
    if (options == null || options.isEmpty) {
      _stream.sink.addError(Exception);
    }
    List<Earthquake> data =
        await _earthquakesRepository.fetchDataSearch(options);
    _stream.sink.add(data);
  }

  void dispose() {
    _earthquakesRepository.api.dispose();
    _stream.close();
  }
}

/// Enum with possible search statuses
///
/// emptySearch : should be yielded when no search terms where given
/// searching : search started (calling api/parsing response)
/// complete : earthquakes have been obtained from the api and are ready to be used by the ui
/// emptyResponse : no earthquakes returned by the api
/// error : something bad happened
enum SearchingStatus {
  emptySearch,
  searching,
  complete,
  emptyResponse,
  error,
}

/// available search fields
///
/// see : [Earthquake] from `lib/src/model/earthquake.dart`
class SearchOptions {
  DateTime startTime;
  DateTime endTime;
  num minMagnitude;
  num maxMagnitude;
  num minDepth;
  num maxDepth;
  num minLatitude;
  num maxLatitude;
  num minLongitude;
  num maxLongitude;

  SearchOptions({
    this.startTime,
    this.endTime,
    this.minMagnitude,
    this.maxMagnitude,
    this.minDepth,
    this.maxDepth,
    this.minLatitude,
    this.maxLatitude,
    this.minLongitude,
    this.maxLongitude,
  });

  /// return true if every field is null
  bool get isEmpty => [
        this.startTime,
        this.endTime,
        this.minMagnitude,
        this.maxMagnitude,
        this.minDepth,
        this.maxDepth,
        this.minLatitude,
        this.maxLatitude,
        this.minLongitude,
        this.maxLongitude,
      ].where((var field) => field != null).isEmpty;
}
