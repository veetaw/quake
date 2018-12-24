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

  String get applicationName => Intl.message(
        "Quake",
        name: "applicationName",
        desc: "application name",
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
