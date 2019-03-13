import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider {
  /// use this like `_themes["light"]()`
  Map<String, Function> _themes = {
    "light": _getLightTheme,
    "dark": _getDarkTheme,
  };

  // TODO custom dark and light theme
  static ThemeData _getLightTheme() => ThemeData.light();
  static ThemeData _getDarkTheme() => ThemeData.dark();

  List<String> getAllThemes() => _themes.keys.toList();

  ThemeData getThemeByName(String name) {
    var theme = _themes[name];
    if (theme == null) throw Exception('theme not found');
    return theme();
  }

  ThemeData getPrefTheme() => getThemeByName(
        QuakeSharedPreferences().getValue<String>(
          key: QuakeSharedPreferencesKey.theme,
          defaultValue: "light",
        ),
      );

  void savePrefTheme(ThemeData theme) =>
      QuakeSharedPreferences().setValue<String>(
        key: QuakeSharedPreferencesKey.theme,
        value: getThemeName(theme),
      );

  String getThemeName(ThemeData theme) =>
      getAllThemes().singleWhere((k) => getThemeByName(k) == theme);
}
