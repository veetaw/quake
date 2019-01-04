import 'package:flutter/material.dart';
import 'package:quake/src/locale/localizations.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  static const double _kAppBarElevation = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        brightness: Theme.of(context)
            .brightness, // make status bar icons dark or light depending on the brightness
        centerTitle: Theme.of(context).platform ==
            TargetPlatform.iOS, // center title if running on ios
        primary: true,
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
        title: Text(QuakeLocalizations.of(context).title),
        elevation: _kAppBarElevation,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(
              icon: Icons.chrome_reader_mode,
              text: QuakeLocalizations.of(context).all),
          _buildBottomNavigationBarItem(
              icon: Icons.location_on,
              text: QuakeLocalizations.of(context).nearby),
          _buildBottomNavigationBarItem(
              icon: Icons.map, text: QuakeLocalizations.of(context).map),
        ],
        currentIndex: 0, // TODO, bloc
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    @required IconData icon,
    @required String text,
  }) =>
      BottomNavigationBarItem(
        icon: Icon(icon),
        title: Text(text),
      );
}
