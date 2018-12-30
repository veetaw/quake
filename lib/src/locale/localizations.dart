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
}

class _QuakeLocalizationsDelegate
    extends LocalizationsDelegate<QuakeLocalizations> {
  static const List<String> supportedLocales = ['en'];

  @override
  bool isSupported(Locale locale) =>
      supportedLocales.contains(locale.languageCode);

  @override
  Future<QuakeLocalizations> load(Locale locale) =>
      QuakeLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<QuakeLocalizations> old) => false;
}
