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

  test('try to fetch earthquakes directly from the repository', () async {
    EarthquakesRepository earthquakesRepository = EarthquakesRepository();
    var data = await earthquakesRepository.fetchData();
    expect(data, isNotNull);
    expect(data, isList);
    expect(data[0].eventLocationName, isNotNull);
  });

  // TODO:
  // skip this because it fails for some strange reason
  // exception: `NoSuchMethodError: The method 'openUrl' was called on null.`
  test('check if earthquakesbloc fetches data correctly', () {
    bloc.fetchData();

    // register a listener then fetch data
    bloc.earthquakes.listen((var data) {
      expect(data, isNotNull);
      expect(data, isList);
      expect(data[0].eventLocationName, isNotNull);
    });
  });

  test('try to test earthquakes search bloc', () {
    searchBloc.search(
      options: SearchOptions(
        startTime: DateTime.now().subtract(Duration(days: 1)),
        endTime: DateTime.now(),
      ),
    );

    searchBloc.earthquakes.listen((var data) {
      expect(data, isNotNull);
      expect(data, isList);
      expect(data[0].eventLocationName, isNotNull);
    });
  });
}
