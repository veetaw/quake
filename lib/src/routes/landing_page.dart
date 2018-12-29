import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:quake/src/locale/localizations.dart';

class LandingPage extends StatelessWidget {
  final PageController _controller = PageController();

  final List<Widget> _pages = <Widget>[
    _LandingPageScreen(
      backgroundColor: _IntroTheme._kLightBlue,
    ),
    _LandingPageScreen(
      backgroundColor: _IntroTheme._kLightGreen,
    ),
    _LandingPageScreen(
      backgroundColor: _IntroTheme._kGreen,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: <Widget>[
            PageView.builder(
              itemCount: _pages.length,
              controller: _controller,
              itemBuilder: (BuildContext context, int page) =>
                  _pages[page % _pages.length],
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
                    itemCount: _pages.length,
                    dotMaxZoom: 1.5,
                    dotSize: 5.0,
                    dotSpacing: 15.0,
                    color: _IntroTheme._kDotColor,
                    leading: _buildMaterialButton(
                      title: QuakeLocalizations.of(context).skip,
                      skip: true,
                    ),
                    trailing: _buildMaterialButton(
                      title: QuakeLocalizations.of(context).next,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  /// util to build the two bottom buttons
  MaterialButton _buildMaterialButton({
    @required String title,
    bool skip = false,
  }) {
    const Curve _kCurve = Curves.ease;
    const Duration _kDuration = Duration(milliseconds: 300);

    return MaterialButton(
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontFamily: _IntroTheme._kFontFamily,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () => skip
          ? _controller.animateToPage(
              _pages.length - 1,
              curve: _kCurve,
              duration: _kDuration,
            )
          : _controller.nextPage(
              curve: _kCurve,
              duration: _kDuration,
            ),
    );
  }
}

/// This represents a page of the initial introuction to the app
class _LandingPageScreen extends StatelessWidget {
  final Color backgroundColor;

  _LandingPageScreen({
    @required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          color: backgroundColor,
        ),
      );
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
///
/// TODO: add trailing and leading for "SKIP" and "NEXT" button
class DotsRow extends AnimatedWidget {
  final PageController controller;
  final int itemCount;
  final double dotSize;
  final double dotMaxZoom;
  final double dotSpacing;
  final Color color;

  final MaterialButton leading;
  final MaterialButton trailing;

  DotsRow({
    @required this.controller,
    @required this.itemCount,
    @required this.dotSize,
    @required this.dotMaxZoom,
    @required this.dotSpacing,
    @required this.leading,
    @required this.trailing,
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

  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          leading,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(itemCount, _buildDot),
          ),
          trailing,
        ],
      );
}

/// This should not depend on theme.
class _IntroTheme {
  static const Color _kLightBlue = Color(0xFF48BEFF);
  static const Color _kLightGreen = Color(0xFF3DFAFF);
  static const Color _kGreen = Color(0xFF43C59E);
  static const Color _kDotColor = Color(0xFFFFFFFF);
  static const String _kFontFamily = "Montserrat";
}
