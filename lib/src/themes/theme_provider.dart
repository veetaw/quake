import 'package:flutter/material.dart';

import 'package:quake/src/utils/quake_shared_preferences.dart';

class ThemeProvider {
  /// use this like `_themes["light"]()`
  Map<String, Function> _themes = {
    "light": _getLightTheme,
    "dark": _getDarkTheme,
    "indigoLight": _getIndigoLightTheme,
  };

  static ThemeData _getLightTheme() => ThemeData.light().copyWith(
        primaryColor: Colors.black,
        iconTheme: ThemeData.light().iconTheme.copyWith(
              color: Colors.black,
            ),
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
            iconTheme: IconThemeData(color: Colors.black), color: Colors.white),
        primaryIconTheme:
            ThemeData.light().primaryIconTheme.copyWith(color: Colors.black),
        primaryTextTheme:
            ThemeData.light().primaryTextTheme.apply(bodyColor: Colors.black),
      );
  static ThemeData _getDarkTheme() => ThemeData.dark();
  static ThemeData _getIndigoLightTheme() => ThemeData.light().copyWith(
        primaryColorDark: Color(0xff303F9F),
        primaryColorLight: Color(0xffC5CAE9),
        primaryColor: Color(0xff3F51B5),
        dividerColor: Color(0xffBDBDBD),
        accentColor: Color(0xff009688),
        iconTheme:
            ThemeData.light().iconTheme.copyWith(color: Color(0xff3F51B5)),
        brightness: Brightness.dark,
      );

  List<String> getAllThemes() => _themes.keys.toList();

  ThemeData getThemeByName(String name) {
    var theme = _themes[name];
    if (theme == null) throw ThemeNotFoundException;
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

class ThemeNotFoundException implements Exception {}
