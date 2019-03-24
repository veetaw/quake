import 'dart:async';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the class containing all the sharedPreferences keys.
/// TODO(REFACTOR): ALL KEYS SHOULD BE ADDED
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
