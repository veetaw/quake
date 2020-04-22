import 'package:flutter/material.dart';
import 'package:quake/screens/home/components/magnitude_selector.dart';

class MagnitudeRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final bool isPortrait = mediaQuery.orientation == Orientation.portrait;

    return Row(
      mainAxisAlignment: isPortrait
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          "Magnitude",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        MagnitudeSelector(
          initialValue: 1,
          notifier: (newIndex) {},
        ),
        Text(
          "-",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        MagnitudeSelector(
          initialValue: 12,
          notifier: (newIndex) {},
        ),
      ],
    );
  }
}
