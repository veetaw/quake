import 'package:flutter/material.dart';

class HomePageNearby extends StatelessWidget {
  static HomePageNearby _instance = HomePageNearby._();
  HomePageNearby._();
  factory HomePageNearby() => _instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(this.hashCode.toString()),
    );
  }
}
