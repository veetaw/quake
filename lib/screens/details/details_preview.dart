import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quake/models/earthquake.dart';

class DetailsPreview extends StatelessWidget {
  final Earthquake earthquake;

  const DetailsPreview({
    @required this.earthquake,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double width = mediaQuery.size.width;
    final double height = mediaQuery.size.height;

    final bool isPortrait = mediaQuery.orientation == Orientation.portrait;

    return Hero(
      tag: earthquake,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 8.0,
          sigmaY: 8.0,
        ),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(),
        ),
      ),
    );
  }
}
