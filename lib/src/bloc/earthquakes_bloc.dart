import 'package:quake/src/data/ingv_api.dart';
import 'package:quake/src/model/earthquake.dart';
import 'package:rxdart/rxdart.dart';

class EarthquakesRepository {
  IngvAPI api = IngvAPI();

  Future<List<Earthquake>> fetchData() async => api.getData();
}

/// Singleton class that represents the bloc to fetch earthquakes
class EarthquakesBloc {
  static EarthquakesBloc _instance = EarthquakesBloc._();
  EarthquakesBloc._();
  factory EarthquakesBloc() => _instance;

  final EarthquakesRepository _earthquakesRepository = EarthquakesRepository();
  final PublishSubject _stream = PublishSubject<List<Earthquake>>();

  Observable<List<Earthquake>> get earthquakes => _stream.stream;

  void fetchData() async {
    _stream.sink.add(await _earthquakesRepository.fetchData());
  }

  // must be called by the subscriber in order to correctly free resources
  void dispose() {
    _earthquakesRepository.api.dispose();
    _stream.close();
  }
}
