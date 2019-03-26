import 'dart:async';

abstract class HomePageScreenBase {
  int get index;
}

class HomePageScreenBloc {
  final StreamController<HomePageScreenBase> _stream = StreamController<HomePageScreenBase>();
  Stream<HomePageScreenBase> get pageStream => _stream.stream;
  
  set page(HomePageScreenBase newPage) => _stream.sink.add(newPage);

  /// must be called in order to correctly close streams
  void dispose() {
    _stream.close();
  }
}
