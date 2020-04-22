import 'package:flutter/material.dart';

class DateSelectionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double width = mediaQuery.size.width;
    final double height = mediaQuery.size.height;

    final bool isPortrait = mediaQuery.orientation == Orientation.portrait;

    const int daysPerRow = 6;

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        for (int i = 0; i < daysPerRow; i++)
          Container(
            width: width / (isPortrait ? 8 : 16),
            height: height / (isPortrait ? 16 : 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            child: Center(
              child: Text(
                DateTime.now().subtract(Duration(days: daysPerRow - i)).day.toString(),
                style: Theme.of(context).accentTextTheme.headline4.copyWith(color: Colors.white), // todo color
              ),
            ),
          ),
      ],
    );
  }
}
