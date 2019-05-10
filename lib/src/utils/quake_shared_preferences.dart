import 'dart:async';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the class containing all the sharedPreferences keys.
class QuakeSharedPreferencesKey {
  /// This key is used to check if the user has already opened the app before.
  ///
  /// It should be a [bool] and it should be set to true only after the user
  /// has finished the intro at [LandingPage].
  static get firstTime => "firstTime";

  /// This key is used to save the app's theme from settings.
  ///
  /// It should be a [String] and must only assume the values
  /// of the keys of [_themes] inside [ThemeProvider].
  static get theme => "theme";

  /// This keys is used to prevent fetching data from server multiple times
  /// in a short timestamp.
  ///
  /// It should be a [int] and it should represent the unix timestamp of the
  /// last time the app has fetched earthquakes from the server.
  static get lastEarthquakesFetch => "lastEarthquakesFetch";

  /// This key stores the time delta between new queries to the api
  ///
  /// It should be a [int] and it should represent a time delta expressed
  /// in milliseconds, for example two minutes are 2*60000 = 120000 ms.
  static get fetchUpdatesDelta => "fetchUpdatesDelta";

  /// This key is set to true if the user gave location permission
  ///
  /// It should be a [bool].
  static get hasLocationSaved => "hasLocationSaved";

  /// This key contains the latitude of the user
  ///
  /// It should be a [double] and it should be set after the user
  /// gave the permission.
  static get latitude => "latitude";

  /// This key contains the longitude of the user
  ///
  /// Same as [latitude]
  static get longitude => "longitude";

  /// This key contains a enum key that represents the map tiles provider
  ///
  /// It should be a [String] and it should contain a .toString of the enum
  /// key ([MapStyles]).
  static get mapTilesProvider => "mapTilesProvider";

  /// This key contains a enum key that represents the current unit of distance
  ///
  /// It should be a [String] and it should contain a .toString of the enum
  /// key ([UnitOfMeasurement]).
  static get unitOfMeasurement => "unitOfMeasurement";

  /// This key contains the id of the last fetched earthquake
  ///
  /// It should be a [String].
  static get lastEarthquakeID => "lastEarthquakeId";

  /// This key contains true if the app should fetch earthquakes in the background
  /// for notifications
  ///
  /// It should be a [bool].
  static get notificationsEnabled => "notificationsEnabled";

  /// This key contains the website where to query for earthquakes
  ///
  /// It should be a [EarthquakesListSource.toString].
  static get earthquakesSource => "earthquakesSource";
}

/// This class is a helper for [SharedPreferences].
class QuakeSharedPreferences {
  /// Returns the instance of [QuakeSharedPreferences]
  static QuakeSharedPreferences _instance = QuakeSharedPreferences._();

  QuakeSharedPreferences._();

  /// Contains and initializes a singleton of [QuakeSharedPreferences]
  factory QuakeSharedPreferences() => _instance;

  /// instance of [SharedPreferences]
  SharedPreferences _sharedPreferences;

  /// this MUST be called before any call to any of the function of this class
  /// in order to instanciate [_sharedPreferences].
  Future<void> init() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  /// Sets value of a given [key] to [value].
  ///
  /// The function is going to create the field if it does not exist yet
  void setValue<T>({
    @required String key,
    @required T value,
  }) {
    String _key = key.toString();
    switch (T) {
      case double:
        _sharedPreferences.setDouble(_key, value as double);
        break;
      case int:
        _sharedPreferences.setInt(_key, value as int);
        break;
      case String:
        _sharedPreferences.setString(_key, value as String);
        break;
      case bool:
        _sharedPreferences.setBool(_key, value as bool);
        break;
      default:
        throw SharedPreferencesException("unknown type : $T");
        break;
    }
  }

  /// Get value of type [T] from sharedPreferences.
  ///
  /// If there is no key in the sharedPreferences that matches [key]
  /// and no [defaultValue] is passed it's going to return null.
  T getValue<T>({
    @required String key,
    T defaultValue,
  }) =>
      (_sharedPreferences.get(key.toString()) ?? defaultValue) as T;

  /// Deletes entry with key [key]
  void removeValue({
    @required String key,
  }) =>
      _sharedPreferences.remove(key.toString());
}

/// Exception thrown by [QuakeSharedPreferences]
class SharedPreferencesException implements Exception {
  final String message;

  SharedPreferencesException(this.message);
}
