import 'package:quake/src/app.dart';
import 'package:quake/src/routes/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<bool> isFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  /// query SharedPreferences for a bool named firstTime, if it's not present in the "DB" return true
  bool firstTime = prefs.getBool("firstTime") ?? true;

  /// if it's the first time now it won't be the next time, so set it to false  D:
  if (firstTime) prefs.setBool("firstTime", false);

  return firstTime;
}

main() async {
  if (await isFirstTime())
    runApp(LandingPage());
  else
    runApp(Home());
}
