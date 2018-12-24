import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test with shared preferences set to first time", () {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{"firstTime": true};
      }
      return null;
    });
  });

  group("Test with shared preferences not set to first time", () {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{"firstTime": false};
      }
      return null;
    });
  });
}
