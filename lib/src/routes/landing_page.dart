import 'dart:math';

import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Container(
                  color: _IntroPalette._kLightBlue,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Container(color: _IntroPalette._kLightGreen),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Container(
                  color: _IntroPalette._kGreen,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: DotsRow(
                  controller: _controller,
                  itemCount: 3,
                  dotMaxZoom: 1.5,
                  dotSize: 5.0,
                  dotSpacing: 15.0,
                  color: _IntroPalette._kDotColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// dots row model (maybe should be moved to `ui/models/` (or maybe `models/ui/`))
/// inspired from https://gist.github.com/collinjackson/4fddbfa2830ea3ac033e34622f278824
///
/// @params:
/// [controller] : a PageController, used to check the actual index of the page
/// [itemCount] : how many dots should be created and displayed
/// [dotSize] : dot radius
/// [dotMaxZoom] : how many times should be increased the dot when "active"
/// [dotSpacing] : the space between dots
/// [color] : dots' color
class DotsRow extends AnimatedWidget {
  final PageController controller;
  final int itemCount;
  final double dotSize;
  final double dotMaxZoom;
  final double dotSpacing;
  final Color color;

  DotsRow({
    @required this.controller,
    @required this.itemCount,
    @required this.dotSize,
    @required this.dotMaxZoom,
    @required this.dotSpacing,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// builds a dingle dot
  Widget _buildDot(int index) {
    double _selectedZoom = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (dotMaxZoom - 1.0) * _selectedZoom;
    return Container(
      width: dotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: Container(
            width: dotSize * zoom,
            height: dotSize * zoom,
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

/// This should not depend on theme.
class _IntroPalette {
  static const Color _kLightBlue = Color(0xFF48BEFF);
  static const Color _kLightGreen = Color(0xFF3DFAFF);
  static const Color _kGreen = Color(0xFF43C59E);
  static const Color _kDotColor = Color(0xFFFFFFFF);
}
