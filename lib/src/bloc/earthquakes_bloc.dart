import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

import 'package:quake/src/bloc/bloc_provider.dart';
import 'package:quake/src/data/ingv_api.dart';
import 'package:quake/src/db/earthquake_provider.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';

/// Contains every possible API where to fetch earthquakes
enum EarthquakesListSource { ingv }

/// This BLoC takes care of fetching earthquakes and searching for them
/// based on the options given.
class EarthquakesBloc extends BlocBase {
  /// This stream should be used only in the main screen (all earthquakes)
  PublishSubject<List<Earthquake>> _streamController = PublishSubject();

  /// This stream unlike [_streamController] should be used, basically, by
  /// every other scren that needs to access a list of earthquakes like:
  /// nearby and a search screen.
  PublishSubject<List<Earthquake>> _searchController = PublishSubject();

  /// Instance of [QuakeSharedPreferences] used to access some keys.
  QuakeSharedPreferences _quakeSharedPreferences = QuakeSharedPreferences();

  /// Instance of [EarthquakePersistentCacheProvider] used to access the database.
  EarthquakePersistentCacheProvider _earthquakePersistentCacheProvider =
      EarthquakePersistentCacheProvider();

  /// exposes [_streamController]'s stream
  Stream get earthquakes => _streamController.stream;

  /// exposes [_searchController]'s stream;
  Stream get searchedEarthquakes => _searchController.stream;

  /// This *must* be called before using every method of this class, otherwise it
  /// will result in a crash.
  Future initializeCacheDatabase() async =>
      await _earthquakePersistentCacheProvider.open('quake_test.db');

  /// Since it's useless for me to cache nearby earthquakes permanently, I cache
  /// only temporarly
  static List<Earthquake> _nearbyCache = List();

  /// Fetches data from the API using the default options
  ///
  /// The parameter [source] defines the API where to fetch the data, it actually
  /// defaults to the only source available: [EarthquakesListSource.ingv].
  /// The app doesn't fetch new earthquakes if the last fetch was made less than
  /// [QuakeSharedPreferencesKey.fetchUpdatesDelta] milliseconds ago, but you can
  /// force-fetch new data using the parameter [force]. Avoid force-fetching too
  /// many times because it's slow, set [force] to true only if this function is
  /// called by a pull to refresh (or something like that).
  Future fetchData({
    EarthquakesListSource source: EarthquakesListSource.ingv,
    bool force: false,
  }) async {
    List<Earthquake> _data = List();

    // Stores the last fetch's timestamp to ensure that the app won't query the server too often
    int lastFetchTimestamp = _quakeSharedPreferences.getValue<int>(
      key: QuakeSharedPreferencesKey.lastEarthquakesFetch,
    );

    int deltaTime = _quakeSharedPreferences.getValue<int>(
      key: QuakeSharedPreferencesKey.fetchUpdatesDelta,
      defaultValue: 10 * 60000, // 10 minutes
    );

    int actualTimeMs = DateTime.now().millisecondsSinceEpoch;

    switch (source) {
      case EarthquakesListSource.ingv:
        if (force ||
            lastFetchTimestamp == null ||
            actualTimeMs - lastFetchTimestamp >= deltaTime) {
          IngvAPI _api = IngvAPI();
          try {
            _data = await _api.getData();
          } catch (e) {
            _streamController.sink.addError(e);
            return;
          }
          // clear cache before saving new data to avoid DB getting bigger and bigger
          await _earthquakePersistentCacheProvider.dropCache();
          _earthquakePersistentCacheProvider.addEarthquakes(earthquakes: _data);

          _quakeSharedPreferences.setValue<int>(
            key: QuakeSharedPreferencesKey.lastEarthquakesFetch,
            value: actualTimeMs,
          );
        } else {
          _data = await _earthquakePersistentCacheProvider.getAllEarthquakes();
        }
        break;
      default:
        _streamController.sink.addError(UnknownSourceException);
        break;
    }

    _data = _data..sort((e1, e2) => e2.time.compareTo(e1.time));

    // finally push data through the stream
    _streamController.sink.add(_data);

    _quakeSharedPreferences.setValue<int>(
      key: QuakeSharedPreferencesKey.lastEarthquakeID,
      value: _data.first.eventID,
    );
  }

  /// Fetch earthquakes by passing options
  ///
  /// See [SearchOptions] to understand what [options] can be set.
  /// See [fetchData] for [source]
  Future search({
    @required SearchOptions options,
    EarthquakesListSource source: EarthquakesListSource.ingv,
    bool force: false,
  }) async {
    List<Earthquake> _data = List();

    if (options.isEmpty)
      return _searchController.sink.addError(EmptySearchOptionsException);

    if (force || _nearbyCache.length == 0) {
      switch (source) {
        case EarthquakesListSource.ingv:
          IngvAPI _api = IngvAPI();

          try {
            _data = await _api.getData(
              startTime: options.startTime,
              endTime: options.endTime,
              minMagnitude: options.minMagnitude,
              maxMagnitude: options.maxMagnitude,
              minDepth: options.minDepth,
              maxDepth: options.maxDepth,
              minLatitude: options.minLatitude,
              maxLatitude: options.maxLatitude,
              minLongitude: options.minLongitude,
              maxLongitude: options.maxLongitude,
            );
          } catch (e) {
            _searchController.sink.addError(e);
            return;
          }

          // force is true on search not nearby, so don't cache search
          if (!force) {
            _nearbyCache = _data;
          }

          break;
        default:
          _searchController.sink.addError(UnknownSourceException);
          break;
      }
    } else {
      // HACK
      await Future.delayed(Duration(microseconds: 1));

      _data = _nearbyCache;
    }

    _searchController.sink
        .add(_data..sort((e1, e2) => e2.time.compareTo(e1.time)));
  }

  Future<Earthquake> fetchLast(
      {EarthquakesListSource source: EarthquakesListSource.ingv}) async {
    switch (source) {
      case EarthquakesListSource.ingv:
        IngvAPI api = IngvAPI();
        return (await api.getData(limit: 1)).first;
      default:
        throw UnknownSourceException;
    }
  }

  /// Close the streams
  @override
  void dispose() {
    _streamController.close();
    _searchController.close();
  }
}

/// Thrown when passing an unknown or unsupported source
class UnknownSourceException implements Exception {
  final EarthquakesListSource badSource;
  String message;

  UnknownSourceException(
    this.badSource,
  ) : message = "$badSource is not a valid source for earthquakes";
}

/// Thrown when the search function of [EarthquakesBloc.search] has received
/// empty search options, so it cannot perform search.
class EmptySearchOptionsException implements Exception {}

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
