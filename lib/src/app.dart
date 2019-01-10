import 'package:flutter/material.dart';
import 'package:quake/src/bloc/home_screen_switch_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/homepage_all.dart';
import 'package:quake/src/model/homepage_map.dart';
import 'package:quake/src/model/homepage_nearby.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  static const double _kAppBarElevation = 2.0;
  final HomeScreenSwitchBloc indexBloc = HomeScreenSwitchBloc();
  final List screens = List.unmodifiable([HomePageAll(), null, null]);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: indexBloc.index,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
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
                tooltip: QuakeLocalizations.of(context).searchTooltip,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
                tooltip: QuakeLocalizations.of(context).settingsTooltip,
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
            currentIndex: snapshot.data ?? 0,
            onTap: (int index) => indexBloc.setIndex(index),
          ),
          body: _getWidget(snapshot.data),
        );
      },
    );
  }

  Widget _getWidget(int index) {
    if(screens[index] == null) {
      if(index == 2) {
        screens[index] = HomePageNearby();
      } else if(index == 3) {
        screens[index] = HomePageMap();
      }
    }
    return screens[index ?? 0];
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    @required IconData icon,
    @required String text,
  }) =>
      BottomNavigationBarItem(
        icon: Icon(icon),
        title: Text(text),
      );

  @override
  void dispose() {
    indexBloc.dispose();
    super.dispose();
  }
}
