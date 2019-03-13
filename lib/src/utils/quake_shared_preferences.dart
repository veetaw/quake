import 'dart:async';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum QuakeSharedPreferencesKey { firstTime, theme } //TODO:REFACTOR IN PROGRESS

// singleton utility class to interact with sharedPreferences
class QuakeSharedPreferences {
  static QuakeSharedPreferences _instance = QuakeSharedPreferences._();
  QuakeSharedPreferences._();
  factory QuakeSharedPreferences() => _instance;

  SharedPreferences _sharedPreferences;

  // this MUST be called before any call to any of the function of this class
  Future<void> init() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  // sets value of a given [key] to [value]
  // the function is going to create the field if it does not exist yet
  void setValue<T>({
    @required QuakeSharedPreferencesKey key,
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

  // returns the value that has been setted with [setValue()]
  // if there is no key in the sharedPreferences that matches [key]
  // and no [defaultValue] is passed it's going to return null
  T getValue<T>({
    @required QuakeSharedPreferencesKey key,
    T defaultValue,
  }) =>
      (_sharedPreferences.get(key.toString()) ?? defaultValue) as T;

  // deletes entry with key [key]
  void removeValue({
    @required QuakeSharedPreferencesKey key,
  }) =>
      _sharedPreferences.remove(key.toString());
}

class SharedPreferencesException implements Exception {
  final String message;

  SharedPreferencesException(this.message);
}
