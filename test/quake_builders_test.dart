// tests:
// test both of the builders with
// no onLoading and onError
// no builder no stream/future

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quake/src/model/quake_builders.dart';
import 'package:quake/src/utils/quake_error.dart';

main() {
  StreamController<String> streamController = StreamController.broadcast();
  group(
    "check if QuakeStreamBuilder works correctly with all parameters ok",
    () {
      testWidgets(
        "QuakeStreamBuilder should build correcyly with initialData passed",
        (tester) async {
          await tester.pumpWidget(
            TestWidget(
              streamController: streamController,
              initialData: 'ok',
            ),
          );

          expect(find.text('ok'), findsOneWidget);
          expect(find.text('loading'), findsNothing);
          expect(find.text('error'), findsNothing);
        },
      );
    },
  );
  group(
    "check if QuakeStreamBuilder works correctly with real world like data flow",
    () {
      testWidgets(
        "QuakeStreamBuilder should handle correctly loading",
        (tester) async {
          await tester.pumpWidget(
            TestWidget(
              streamController: streamController,
            ),
          );

          expect(find.text('loading'), findsOneWidget);
          expect(find.text('ok'), findsNothing);
          expect(find.text('error'), findsNothing);
        },
      );

      testWidgets(
        "QuakeStreamBuilder should handle correctly error",
        (tester) async {
          await tester.pumpWidget(
            TestWidget(
              streamController: streamController,
            ),
          );

          expect(find.text('loading'), findsOneWidget);
          expect(find.text('ok'), findsNothing);
          expect(find.text('error'), findsNothing);

          streamController.sink.addError(Exception());
          await tester.pumpAndSettle();

          expect(find.text('error'), findsOneWidget);
          expect(find.text('loading'), findsNothing);
          expect(find.text('ok'), findsNothing);
        }, skip: true,
      );
    },
  );

  group(
    "QuakeStreamBuilder should work correctly even with just stream and builder",
    () {
      testWidgets(
        "default loading",
        (tester) async {
          await tester.pumpWidget(
            TestWidget(
              streamController: streamController,
              handleCallbacks: false,
            ),
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      testWidgets(
        "default error",
        (tester) async {
          await tester.pumpWidget(
            TestWidget(
              streamController: streamController,
              handleCallbacks: false,
            ),
          );

          expect(find.byType(Container), findsOneWidget);
        },
      );
    },
  );

  tearDownAll(() {
    streamController.close();
  });
}

class TestWidget extends StatelessWidget {
  final StreamController<String> streamController;
  final String initialData;
  final bool handleCallbacks;

  const TestWidget({
    Key key,
    this.streamController,
    this.initialData,
    this.handleCallbacks: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: QuakeStreamBuilder<String>(
          stream: streamController.stream,
          initialData: initialData,
          onError: handleCallbacks ? (QuakeError error) => Text('error') : null,
          onLoading: handleCallbacks ? () => Text('loading') : null,
          builder: (context, data) {
            return Text(data);
          },
        ),
      ),
    );
  }
}
