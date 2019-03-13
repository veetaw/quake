import 'dart:async';

import 'package:flutter/material.dart';
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

  Future<ThemeData> getPrefTheme() async {
    var prefs = await SharedPreferences.getInstance();

    return getThemeByName(prefs.getString("theme") ?? "light");
  }

  Future<void> savePrefTheme(ThemeData theme) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString("theme", getThemeName(theme));
  }

  String getThemeName(ThemeData theme) =>
      getAllThemes().singleWhere((k) => getThemeByName(k) == theme);
}
