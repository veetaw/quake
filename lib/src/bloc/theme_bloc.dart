import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quake/src/themes/theme_provider.dart';

class ThemeBloc {
  final StreamController<ThemeData> _stream = StreamController<ThemeData>();
  StreamSubscription _subscription;

  static ThemeBloc _instance = ThemeBloc._();
  ThemeBloc._();
  factory ThemeBloc() => _instance;

  Stream<ThemeData> get themeStream => _stream.stream;

  /// use this as setTheme(Theme)
  set theme(ThemeData theme) {

    _stream.sink.add(theme);

    ThemeProvider().savePrefTheme(theme);

  }
  /// must be called in order to correctly close the stream
  void dispose() {
    _subscription.cancel();
    _stream.close();
  }
}
