import 'dart:async';

class HomeScreenSwitchBloc {
  final StreamController<int> _indexStream = StreamController<int>();
  Stream<int> get index => _indexStream.stream;
  Function get setIndex => _indexStream.sink.add;

  /// must be called in order to correctly close streams
  void dispose() {
    _indexStream.close();
  }
}
