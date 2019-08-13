import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Test landing page', () {
    final pageView = find.byValueKey("landing_slider");
    final nextButton = find.byValueKey("next_button");

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    test(
        'Test previous button hidden when current page'
        ' is zero', () {
      expect(_isPresent(find.byValueKey("previous_button"), driver), isFalse);
    });

    test('Test page switching', () async {
      // scroll two pages
      await driver.scroll(pageView, 300, 0, Duration(milliseconds: 300));
      expect(await driver.getText(nextButton), equals("next"));

      await driver.scroll(pageView, 300, 0, Duration(milliseconds: 300));
      expect(await driver.getText(nextButton), equals("finish"));
    });

    test('Test page switching using buttons', () async {
      // scroll two pages
      await driver.tap(nextButton);
      expect(await driver.getText(nextButton), equals("next"));

      await driver.tap(nextButton);
      expect(await driver.getText(nextButton), equals("finish"));

      await driver.tap(find.byValueKey("previous_button"));
      expect(await driver.getText(nextButton), equals("next"));
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
  });
}

Future<bool> _isPresent(
  SerializableFinder finder,
  FlutterDriver driver, {
  Duration timeout = const Duration(seconds: 1),
}) async {
  try {
    await driver.waitFor(finder, timeout: timeout);
    return true;
  } catch (e) {
    return false;
  }
}
