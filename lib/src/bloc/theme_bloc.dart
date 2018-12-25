import 'dart:async';

import 'package:flutter/material.dart';

class ThemeBloc {
  final StreamController<ThemeData> _stream = StreamController<ThemeData>();
  StreamSubscription _subscription;

  static ThemeBloc _instance = ThemeBloc._();
  ThemeBloc._();
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
