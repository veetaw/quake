// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  get localeName => 'en';

  static m0(location, magnitude, country, time) => "${time}: Registered an earthquake of ${magnitude} on Richter Scale in ${location} (${country}).\n\nShared with Quake.";

  static m1(e) => "Something really bad happened and I can\'t handle it.\nTechnical Details: ${e}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "advancedSearch" : MessageLookupByLibrary.simpleMessage("Advanced search"),
    "alertCancelButton" : MessageLookupByLibrary.simpleMessage("cancel"),
    "alertOkButton" : MessageLookupByLibrary.simpleMessage("ok"),
    "all" : MessageLookupByLibrary.simpleMessage("All"),
    "allEarthquakesError" : MessageLookupByLibrary.simpleMessage("Failed to get the list of earthquakes, try again later because something bad happened."),
    "appStatusDescription" : MessageLookupByLibrary.simpleMessage("The app is in an active development state. Help the developer by reporting bug or suggesting features to add."),
    "appStatusTitle" : MessageLookupByLibrary.simpleMessage("You can make Quake better!"),
    "appearance" : MessageLookupByLibrary.simpleMessage("Appearance"),
    "applicationName" : MessageLookupByLibrary.simpleMessage("Quake"),
    "badResponse" : MessageLookupByLibrary.simpleMessage("Got bad response from the server, retry later."),
    "baseMap" : MessageLookupByLibrary.simpleMessage("Base map"),
    "chooseTheme" : MessageLookupByLibrary.simpleMessage("Choose theme"),
    "chooseThemeLong" : MessageLookupByLibrary.simpleMessage("Change the whole app\'s appearance"),
    "dark" : MessageLookupByLibrary.simpleMessage("Dark"),
    "darkMap" : MessageLookupByLibrary.simpleMessage("Dark map"),
    "depth" : MessageLookupByLibrary.simpleMessage("Depth"),
    "depthKm" : MessageLookupByLibrary.simpleMessage("Depth (km)"),
    "depthSettingsTile" : MessageLookupByLibrary.simpleMessage("Unit of measurement for depth"),
    "distanceMapSettingsTile" : MessageLookupByLibrary.simpleMessage("Distance for near earthquakes"),
    "earthquake" : MessageLookupByLibrary.simpleMessage("Earthquake"),
    "earthquakesCountSettingsTile" : MessageLookupByLibrary.simpleMessage("How many earthquakes to load at time"),
    "emsc" : MessageLookupByLibrary.simpleMessage("European Mediterranean Seismological Centre"),
    "finish" : MessageLookupByLibrary.simpleMessage("finish"),
    "general" : MessageLookupByLibrary.simpleMessage("General"),
    "githubTileDescription" : MessageLookupByLibrary.simpleMessage("Quake is an open source project, PRs with your additions are welcome. If you are having any issues check the issue tracker"),
    "githubTileTitle" : MessageLookupByLibrary.simpleMessage("Contribute to Quake"),
    "indigoLight" : MessageLookupByLibrary.simpleMessage("Indigo Light"),
    "ingv" : MessageLookupByLibrary.simpleMessage("National Institute of Geophysics and Volcanology"),
    "kilometers" : MessageLookupByLibrary.simpleMessage("kilometers"),
    "kilometersShort" : MessageLookupByLibrary.simpleMessage("km"),
    "light" : MessageLookupByLibrary.simpleMessage("Light"),
    "lightMap" : MessageLookupByLibrary.simpleMessage("Light map"),
    "loadingEarthquakeInfos" : MessageLookupByLibrary.simpleMessage("Loading earthquake infos..."),
    "loadingWithDots" : MessageLookupByLibrary.simpleMessage("Loading..."),
    "locationNotEnabled" : MessageLookupByLibrary.simpleMessage("You have never allowed location permission, allow Quake to access it to view nearby earthquakes."),
    "locationPromptAlertContent" : MessageLookupByLibrary.simpleMessage("Quake needs location to show earthquakes nearby, we keep the data in the local storage"),
    "locationPromptAlertTitle" : MessageLookupByLibrary.simpleMessage("Location permission"),
    "magnitude" : MessageLookupByLibrary.simpleMessage("Magnitude"),
    "malformedResponse" : MessageLookupByLibrary.simpleMessage("Bad news here, the server answered in a language that I don\'t speak. Please contact the developer and check for app updates."),
    "map" : MessageLookupByLibrary.simpleMessage("Map"),
    "mapProviderSettingsTile" : MessageLookupByLibrary.simpleMessage("Map Provider"),
    "maxDepth" : MessageLookupByLibrary.simpleMessage("Max depth"),
    "maxMagnitude" : MessageLookupByLibrary.simpleMessage("Max magnitude"),
    "meters" : MessageLookupByLibrary.simpleMessage("meters"),
    "metersShort" : MessageLookupByLibrary.simpleMessage("m"),
    "miles" : MessageLookupByLibrary.simpleMessage("miles"),
    "milesShort" : MessageLookupByLibrary.simpleMessage("mi"),
    "minDepth" : MessageLookupByLibrary.simpleMessage("Min depth"),
    "minMagnitude" : MessageLookupByLibrary.simpleMessage("Min magnitude"),
    "minMagnitudeSettingsTile" : MessageLookupByLibrary.simpleMessage("Minimum magnitude for map marker"),
    "nearNotificationsSettingsTile" : MessageLookupByLibrary.simpleMessage("Only near earthquakes"),
    "nearNotificationsSettingsTileSubtitle" : MessageLookupByLibrary.simpleMessage("You must enable notifications and grant location permission before enabling this."),
    "nearby" : MessageLookupByLibrary.simpleMessage("Nearby"),
    "next" : MessageLookupByLibrary.simpleMessage("next"),
    "noEarthquakes" : MessageLookupByLibrary.simpleMessage("No earthquakes happened in the last 7 days."),
    "noInternetConnection" : MessageLookupByLibrary.simpleMessage("You\'re not connected to internet, you must enable an internet connectionto use Quake."),
    "noResponse" : MessageLookupByLibrary.simpleMessage("Server did not respond, this might be a connection issue or a server issue. Try again later."),
    "notAvailable" : MessageLookupByLibrary.simpleMessage("Not available."),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notifications"),
    "notificationsSettingsTile" : MessageLookupByLibrary.simpleMessage("Enable/Disable notifications."),
    "other" : MessageLookupByLibrary.simpleMessage("Other"),
    "peopleInvolved" : MessageLookupByLibrary.simpleMessage("People involved"),
    "promptForLocationPermissionButton" : MessageLookupByLibrary.simpleMessage("Allow location permission."),
    "search" : MessageLookupByLibrary.simpleMessage("Search earthquake"),
    "searchBoxLabel" : MessageLookupByLibrary.simpleMessage("Search for location"),
    "searchTooltip" : MessageLookupByLibrary.simpleMessage("Search"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsTooltip" : MessageLookupByLibrary.simpleMessage("settings"),
    "shareIntentText" : m0,
    "shareNotAvailable" : MessageLookupByLibrary.simpleMessage("Action not available for this earthquake..."),
    "skip" : MessageLookupByLibrary.simpleMessage("skip"),
    "sourceSettingsTile" : MessageLookupByLibrary.simpleMessage("Earthquake feed source"),
    "specialThanks" : MessageLookupByLibrary.simpleMessage("Special thanks"),
    "specialThanksTile" : MessageLookupByLibrary.simpleMessage("Contributors"),
    "title" : MessageLookupByLibrary.simpleMessage("Quake"),
    "unexpectedException" : m1,
    "welcomeDescription" : MessageLookupByLibrary.simpleMessage("Keep track of the earthquakes near you to stay safe."),
    "welcomeTitle" : MessageLookupByLibrary.simpleMessage("Welcome to Quake!")
  };
}
