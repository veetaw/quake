import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

abstract class BlocBase {
  void dispose();
}

class BlocProvider extends StatefulWidget {
  final Widget child;
  final BlocBase bloc;

  const BlocProvider({
    @required this.bloc,
    @required this.child,
    Key key,
  })  : assert(bloc != null),
        assert(child != null),
        super(key: key);

  @override
  _BlocProviderState createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
