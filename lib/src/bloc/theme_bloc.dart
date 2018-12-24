import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc {
  final StreamController<ThemeData> _stream = StreamController<ThemeData>();
  StreamSubscription _subscription;
  
  static ThemeBloc _instance = ThemeBloc._();
  ThemeBloc._() {
    /// save theme when it's changed
    _subscription = _stream.stream.listen((ThemeData themeData) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      // sharedPreferences.setString("theme", );
      // TODO !!
      // themes should have and ID so it will be possible to save and load themes
    });
  }
  factory ThemeBloc() => _instance;

  Stream<ThemeData> get theme => _stream.stream;
  
  /// use this as setTheme(Theme)
  Function get setTheme => _stream.sink.add;

  /// must be called in order to correctly close the stream
  void dispose() {
    _subscription.cancel();
    _stream.close();
  }
}