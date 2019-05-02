import 'dart:async';

import 'package:quake/src/bloc/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

abstract class HomePageScreenBase {
  int get index;
}

class HomePageScreenBloc extends BlocBase {
  final StreamController<HomePageScreenBase> _stream =
      PublishSubject<HomePageScreenBase>();
  Stream<HomePageScreenBase> get pageStream => _stream.stream;

  set page(HomePageScreenBase newPage) => _stream.sink.add(newPage);

  @override
  void dispose() {
    _stream.close();
  }
}
