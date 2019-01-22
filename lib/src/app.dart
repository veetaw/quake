import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quake/src/bloc/home_screen_switch_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/homepage_all.dart';
import 'package:quake/src/model/homepage_map.dart';
import 'package:quake/src/model/homepage_nearby.dart';
import 'package:connectivity/connectivity.dart';
import 'package:quake/src/model/loading.dart';
import 'package:quake/src/model/error.dart' as error;

class Home extends StatefulWidget {
  static const routeName = "/home";
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  static const double _kAppBarElevation = 2.0;
  final HomeScreenSwitchBloc indexBloc = HomeScreenSwitchBloc();
  final List screens = [HomePageAll(), null, null];

  StreamSubscription _connectionSubscription;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Connectivity().checkConnectivity(),
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot.data == null) return Loading();

        // user is not connected to the internet
        // listen for connectivity changes and return an error message
        if (snapshot.data == ConnectivityResult.none) {
          _listenForConnectionChange();

          return Scaffold(
            appBar: _buildAppBar(context, iconsEnabled: false),
            body: error.ErrorWidget(
                message: QuakeLocalizations.of(context).noInternetConnection),
          );
        } else // user is connected
          return StreamBuilder(
            stream: indexBloc.index,
            initialData: 0, // start with index 0 (all earthquakes)
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Scaffold(
                appBar: _buildAppBar(context),
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
                        icon: Icons.map,
                        text: QuakeLocalizations.of(context).map),
                  ],
                  currentIndex: snapshot.data ?? 0,
                  onTap: (int index) => indexBloc.setIndex(index),
                ),
                body: _getWidget(snapshot.data),
              );
            },
          );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, {bool iconsEnabled=true}) {
    return AppBar(
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
          onPressed: iconsEnabled ? () {/*TODO*/} : null,
          tooltip: QuakeLocalizations.of(context).searchTooltip,
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: iconsEnabled ? () {/*TODO*/} : null,
          tooltip: QuakeLocalizations.of(context).settingsTooltip,
        ),
      ],
    );
  }

  Widget _getWidget(int index) {
    // screens[index] is null on index 1 and 2 because it's useless to instantiate a class if the user hasn't asked for it
    if (screens[index] == null) {
      if (index == 1) {
        screens[index] = HomePageNearby();
      } else if (index == 2) {
        screens[index] = HomePageMap();
      }
    }
    return screens[index];
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
    _connectionSubscription.cancel();
    super.dispose();
  }

  Future<Null> _listenForConnectionChange() async {
    _connectionSubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        // rebuild widget if user enables connection
        if (result != ConnectivityResult.none) setState(() {});
      },
    );
  }
}
