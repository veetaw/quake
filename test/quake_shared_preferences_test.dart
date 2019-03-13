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

    test('put value into empty sharedPreferences and get the value back', () {
      quakeSharedPreferences.setValue<int>(
        key: QuakeSharedPreferencesKey.firstTime,
        value: 10,
      );

      expect(
        quakeSharedPreferences.getValue<int>(
          key: QuakeSharedPreferencesKey.firstTime,
          defaultValue: -1,
        ),
        equals(10),
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
