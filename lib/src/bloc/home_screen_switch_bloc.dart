import 'dart:async';

class HomeScreenSwitchBloc {
  final StreamController<int> _stream = StreamController<int>();
  Stream<int> get index => _stream.stream;
  Function get setIndex => _stream.sink.add;

  /// must be called in order to correctly close streams
  void dispose() {
    _stream.close();
  }
}
