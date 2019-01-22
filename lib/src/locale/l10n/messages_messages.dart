// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'messages';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "alertCancelButton": MessageLookupByLibrary.simpleMessage("cancel"),
        "alertOkButton": MessageLookupByLibrary.simpleMessage("ok"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "allEarthquakesError": MessageLookupByLibrary.simpleMessage(
            "Failed to get the list of earthquakes, try again later because something bad happened."),
        "appStatusDescription": MessageLookupByLibrary.simpleMessage(
            "The app is in an active development state. Help the developer by reporting bug or suggesting features to add."),
        "appStatusTitle":
            MessageLookupByLibrary.simpleMessage("You can make Quake better!"),
        "applicationName": MessageLookupByLibrary.simpleMessage("Quake"),
        "depth": MessageLookupByLibrary.simpleMessage("depth"),
        "finish": MessageLookupByLibrary.simpleMessage("finish"),
        "locationNotEnabled": MessageLookupByLibrary.simpleMessage(
            "You have never allowed location permission, allow Quake to access it to view nearby earthquakes."),
        "locationPromptAlertContent": MessageLookupByLibrary.simpleMessage(
            "Quake needs location to show earthquakes nearby, we keep the data in the local storage"),
        "locationPromptAlertTitle":
            MessageLookupByLibrary.simpleMessage("Location permission"),
        "magnitude": MessageLookupByLibrary.simpleMessage("magnitude"),
        "map": MessageLookupByLibrary.simpleMessage("Map"),
        "nearby": MessageLookupByLibrary.simpleMessage("Nearby"),
        "next": MessageLookupByLibrary.simpleMessage("next"),
        "noEarthquakesNearby": MessageLookupByLibrary.simpleMessage(
            "No earthquakes happened in the last 7 days in your zone."),
        "noInternetConnection": MessageLookupByLibrary.simpleMessage(
            "You\'re not connected to internet, you must enable an internet connectionto use Quake."),
        "promptForLocationPermissionButton":
            MessageLookupByLibrary.simpleMessage("Allow location permission."),
        "searchTooltip": MessageLookupByLibrary.simpleMessage("search"),
        "settingsTooltip": MessageLookupByLibrary.simpleMessage("settings"),
        "skip": MessageLookupByLibrary.simpleMessage("skip"),
        "title": MessageLookupByLibrary.simpleMessage("Quake"),
        "welcomeDescription": MessageLookupByLibrary.simpleMessage(
            "Keep track of the earthquakes near you to stay safe."),
        "welcomeTitle":
            MessageLookupByLibrary.simpleMessage("Welcome to Quake!")
      };
}
