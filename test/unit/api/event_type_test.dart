import 'package:test/test.dart';

import 'package:quake/src/api/model/event_type.dart';

main() {
  group('EventType', () {
    Matcher isDefault = equals(EventType.earthquake);
    Matcher isNuclearExplosion = equals(EventType.nuclearExplosion);

    test('Test with a valid String', () {
      expect(eventTypeFromText("nuclear explosion"), isNuclearExplosion);
    });

    test('Test with null String', () {
      expect(eventTypeFromText(null), isDefault);
    });

    test('Test with empty String', () {
      expect(eventTypeFromText(""), isDefault);
    });

    test('Test with invalid String', () {
      expect(eventTypeFromText("nope"), isDefault);
    });
  });
}
