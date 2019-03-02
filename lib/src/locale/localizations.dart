import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:quake/src/locale/l10n/messages_all.dart';

/// https://flutter.io/docs/development/accessibility-and-localization/internationalization
class QuakeLocalizations {
  static String localeCode;
  static _QuakeLocalizationsDelegate delegate = _QuakeLocalizationsDelegate();

  static Future<QuakeLocalizations> load(Locale locale) {
    final String _name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String _localeName = Intl.canonicalizedLocale(_name);
    QuakeLocalizations.localeCode = _localeName;
    return initializeMessages(_localeName).then((bool _) {
      Intl.defaultLocale = _localeName;
      return QuakeLocalizations();
    });
  }

  static QuakeLocalizations of(BuildContext context) =>
      Localizations.of<QuakeLocalizations>(context, QuakeLocalizations);

  // == SECTION general ==
  String get applicationName => Intl.message(
        "Quake",
        name: "applicationName",
        desc: "application name",
      );

  String get title => Intl.message(
        "Quake",
        name: "title",
      );

  String get earthquake => Intl.message(
        "Earthquake",
        name: "earthquake",
      );

  // == SECTION intro ==
  String get skip => Intl.message(
        "skip",
        name: "skip",
      );

  String get next => Intl.message(
        "next",
        name: "next",
      );

  String get finish => Intl.message(
        "finish",
        name: "finish",
      );

  String get welcomeTitle => Intl.message(
        "Welcome to Quake!",
        name: "welcomeTitle",
        desc: "the title of the first landing page screen",
      );

  String get welcomeDescription =>
      Intl.message("Keep track of the earthquakes near you to stay safe.",
          name: "welcomeDescription",
          desc: "the description of the first landing page screen");

  String get appStatusTitle => Intl.message(
        "You can make Quake better!",
        name: "appStatusTitle",
        desc: "the title of the second landing page screen",
      );

  String get appStatusDescription => Intl.message(
      "The app is in an active development state. Help the developer by reporting bug or suggesting features to add.",
      name: "appStatusDescription",
      desc: "the description of the first landing page screen");

  // == SECTION bottomAppBar ==
  String get all => Intl.message(
        "All",
        name: "all",
      );

  String get nearby => Intl.message(
        "Nearby",
        name: "nearby",
      );

  String get map => Intl.message(
        "Map",
        name: "map",
      );

  // == SECTION tooltips ==
  String get searchTooltip => Intl.message(
        "search",
        name: "searchTooltip",
      );

  String get settingsTooltip => Intl.message(
        "settings",
        name: "settingsTooltip",
      );

  // == SECTION earthquakeCard ==
  String get magnitude => Intl.message(
        "magnitude",
        name: "magnitude",
      );

  String get depth => Intl.message(
        "depth",
        name: "depth",
      );

  // == SECTION error messages ==
  String get allEarthquakesError => Intl.message(
        "Failed to get the list of earthquakes, try again later because something bad happened.",
        name: "allEarthquakesError",
      );

  String get noInternetConnection => Intl.message(
        "You're not connected to internet, you must enable an internet connectionto use Quake.",
        name: "noInternetConnection",
      );

  String get noEarthquakesNearby => Intl.message(
        "No earthquakes happened in the last 7 days in your zone.",
        name: "noEarthquakesNearby",
      );

  // == SECTION nearby screen ==
  String get locationNotEnabled => Intl.message(
        "You have never allowed location permission, allow Quake to access it to view nearby earthquakes.",
        name: "locationNotEnabled",
      );

  String get promptForLocationPermissionButton => Intl.message(
        "Allow location permission.",
        name: "promptForLocationPermissionButton",
      );

  String get locationPromptAlertTitle => Intl.message(
        "Location permission",
        name: "locationPromptAlertTitle",
      );

  String get locationPromptAlertContent => Intl.message(
        "Quake needs location to show earthquakes nearby, we keep the data in the local storage",
        name: "locationPromptAlertContent",
      );

  // == SECTION general alerts ==
  String get alertCancelButton => Intl.message(
        "cancel",
        name: "alertCancelButton",
      );

  String get alertOkButton => Intl.message(
        "ok",
        name: "alertOkButton",
      );
}

class _QuakeLocalizationsDelegate
    extends LocalizationsDelegate<QuakeLocalizations> {
  static const List<String> supportedLocales = ['en', 'it'];

  @override
  bool isSupported(Locale locale) =>
      supportedLocales.contains(locale.languageCode);

  @override
  Future<QuakeLocalizations> load(Locale locale) =>
      QuakeLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<QuakeLocalizations> old) =>
      old != this;
}
