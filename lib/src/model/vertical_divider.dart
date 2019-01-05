import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const VerticalDivider({
    this.width = 2,
    this.height = 50,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color ?? Theme.of(context).dividerColor,
    );
  }
}
