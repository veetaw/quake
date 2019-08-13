import 'package:flutter_test/flutter_test.dart';

import 'package:quake/src/landing/landing_screen.dart';

void main() {
  const int pageCount = 10;
  group('Test page change notifier of landing_screen.dart', () {
    PageChangeNotifier notifier;
    setUp(() {
      notifier = PageChangeNotifier(
        controller: null,
        initialPage: 0,
        pageCount: pageCount,
      );
    });
    test(
        'Test page getter with null initialPage passed to'
        'the constructor', () {
      PageChangeNotifier _notifier = PageChangeNotifier(
        controller: null,
        initialPage: null,
        pageCount: null,
      );

      expect(_notifier.page, isZero);
    });

    test('Test page setter with new page index greater than page count', () {
      final _prev = notifier.page;
      notifier.page = pageCount + 1;

      expect(_prev, equals(notifier.page));
    });

    test('Test listen for page change', (){
      const new_index = 2;
      notifier.addListener(() {
        expect(notifier.page, new_index);
      });

      notifier.page = new_index;
    });

    tearDown((){
      notifier.dispose();
    });
  });
}
