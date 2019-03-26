import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quake/src/bloc/bloc_provider.dart';
import 'package:quake/src/themes/theme_provider.dart';

class ThemeBloc extends BlocBase {
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

  @override
  void dispose() {
    _subscription.cancel();
    _stream.close();
  }
}
