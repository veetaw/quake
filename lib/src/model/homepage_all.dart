import 'package:flutter/material.dart';

class HomePageAll extends StatelessWidget {
  static HomePageAll _instance = HomePageAll._();
  HomePageAll._();
  factory HomePageAll() => _instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(this.hashCode.toString()),
    );
  }
}