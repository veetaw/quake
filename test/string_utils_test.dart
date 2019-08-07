import 'package:test/test.dart';

import 'package:quake/src/common/utils/string_utils.dart';

void main() {
  group("test capitalize function", () {
    test('Test with a null string', () {
      expect(capitalize(null), isNull);
    });

    test('Test with an empty string', () {
      expect(capitalize(""), isEmpty);
    });

    test('Test with a valid string', () {
      expect(capitalize("test"), equals("Test"));
    });
  });

  group("test capitalizeAll function", () {
    test('Test with a null string', () {
      expect(capitalizeAll(null), isNull);
    });

    test('Test with an empty string', () {
      expect(capitalizeAll(""), isEmpty);
    });

    test('Test with a single word string', () {
      expect(capitalizeAll("test"), equals("Test"));
    });

    test('Test with a valid string', () {
      expect(capitalizeAll("test test"), equals("Test Test"));
    });
  });
}
