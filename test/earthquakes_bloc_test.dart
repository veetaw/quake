import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quake/src/bloc/bloc_provider.dart';
import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:quake/src/model/quake_builders.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

// todo mock db

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({}); // empty sharedPreferences

    await QuakeSharedPreferences().init();
  });

  testWidgets("test data", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EarthquakesListTestWidget(),
        ),
      ),
    );
  });
}

class EarthquakesListTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EarthquakesBloc earthquakesBloc = EarthquakesBloc();
    earthquakesBloc.fetchData();
    var blocProvider = BlocProvider(
      bloc: earthquakesBloc,
      child: QuakeStreamBuilder<List<Earthquake>>(
        stream: earthquakesBloc.earthquakes,
        builder: (ctx, data) {
          if (data == null) return Text('nodata');
          return Text('data');
        },
      ),
    );
    return blocProvider;
  }
}
