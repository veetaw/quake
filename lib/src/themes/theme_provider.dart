import 'package:flutter/material.dart';

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
}
