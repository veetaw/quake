import 'package:flutter_test/flutter_test.dart';
import 'package:quake/src/bloc/earthquakes_bloc.dart';

void main() {
  EarthquakesBloc bloc;
  EarthquakesSearchBloc searchBloc;

  setUp(() {
    bloc = EarthquakesBloc();
    searchBloc = EarthquakesSearchBloc();
  });

  test('test if SearchOptions.isEmpty works correctly', () {
    SearchOptions searchOptions = SearchOptions();
    expect(searchOptions.isEmpty, isTrue);
    searchOptions.maxDepth = 0;
    expect(searchOptions.isEmpty, isFalse);
  });

  test('check if earthquakesbloc fetches data correctly', () {
    EarthquakesBloc bloc = EarthquakesBloc();

    /// register a listener then fetch data
    bloc.earthquakes.listen((var data) {
      expect(data, isNotNull);
      expect(data, isList);
      expect(data[0].eventLocationName, isNotNull);
    });
    bloc.fetchData();
  });

  group('try to test earthquakes search bloc', () {
    test('test if a valid search works', () {
      searchBloc.earthquakes.listen((var data) {
        expect(data, isNotNull);
        expect(data, isList);
        expect(data[0].eventLocationName, isNotNull);
      });

      searchBloc.search(
        options: SearchOptions(
          startTime: DateTime.now().subtract(Duration(days: 1)),
          endTime: DateTime.now(),
        ),
      );
    });
  });

  tearDown(() {
    bloc.dispose();
    searchBloc.dispose();
  });
}
