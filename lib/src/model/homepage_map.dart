import 'package:flutter/material.dart';

class HomePageMap extends StatelessWidget {
  static HomePageMap _instance = HomePageMap._();
  HomePageMap._();
  factory HomePageMap() => _instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(this.hashCode.toString()),
    );
  }
}
