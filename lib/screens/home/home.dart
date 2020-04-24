import 'package:flutter/material.dart';
import 'package:quake/components/earthquake_card.dart';
import 'package:quake/models/coordinates.dart';
import 'package:quake/models/earthquake.dart';
import 'package:quake/screens/home/components/custom_app_bar.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CustomAppBar(),
          EarthquakeCard(
            earthquake: Earthquake(
              eventName: "Test earthquake",
              time: DateTime.now(),
              magnitude: 6.8,
              depth: 10,
              coordinates: Coordinates(41.89193, 12.51133),
            ),
          ),
        ],
      ),
    );
  }
}
