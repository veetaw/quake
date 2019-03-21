import 'package:flutter_test/flutter_test.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('test sharedPreferences helper class', () {
    QuakeSharedPreferences quakeSharedPreferences = QuakeSharedPreferences();
    setUp(() async {
      SharedPreferences.setMockInitialValues({}); // empty sharedPreferences

      await quakeSharedPreferences.init();
    });

    test('put a value into empty sharedPreferences and get the value back for every type available', () {
      // int
      quakeSharedPreferences.setValue<int>(
        key: "testInt",
        value: 10,
      );

      expect(
        quakeSharedPreferences.getValue<int>(
          key: "testInt",
          defaultValue: -1,
        ),
        equals(10),
      );

      // bool
      quakeSharedPreferences.setValue<bool>(
        key: QuakeSharedPreferencesKey.firstTime,
        value: true,
      );

      expect(
        quakeSharedPreferences.getValue<bool>(
          key: QuakeSharedPreferencesKey.firstTime,
          defaultValue: false,
        ),
        equals(true),
      );

      // double
      quakeSharedPreferences.setValue<double>(
        key: "testDouble",
        value: 1.5,
      );

      expect(
        quakeSharedPreferences.getValue<double>(
          key: "testDouble",
          defaultValue: 0,
        ),
        equals(1.5),
      );

      // string
      quakeSharedPreferences.setValue<String>(
        key: QuakeSharedPreferencesKey.theme,
        value: "test",
      );

      expect(
        quakeSharedPreferences.getValue<String>(
          key: QuakeSharedPreferencesKey.theme,
          defaultValue: "nope",
        ),
        equals("test"),
      );
    });

    test(
        'remove a value and then ask for it again (it should give null or defaultValue)',
        () {
      quakeSharedPreferences.removeValue(
        key: QuakeSharedPreferencesKey.firstTime,
      );

      expect(
        quakeSharedPreferences.getValue<int>(
          key: QuakeSharedPreferencesKey.firstTime,
        ),
        isNull,
      );

      expect(
        quakeSharedPreferences.getValue<int>(
          key: QuakeSharedPreferencesKey.firstTime,
          defaultValue: -1,
        ),
        equals(-1),
      );
    });

    test('trying to set a value for a not known type should throw Exception',
        () {
      expect(
        () => quakeSharedPreferences.setValue<List>(
              key: null,
              value: null,
            ),
        throwsException,
      );
    });
  });
}
