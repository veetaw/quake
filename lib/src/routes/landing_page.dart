import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(
              color: _IntroPalette._lightBlue,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(color: _IntroPalette._lightGreen),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(
              color: _IntroPalette._green,
            ),
          ),
        ],
      ),
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
