import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:connectivity/connectivity.dart';

import 'package:quake/src/bloc/home_page_screen_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/model/homepage_all.dart';
import 'package:quake/src/model/homepage_map.dart';
import 'package:quake/src/model/homepage_nearby.dart';
import 'package:quake/src/model/error.dart';
import 'package:quake/src/model/quake_builders.dart';
import 'package:quake/src/routes/search.dart';
import 'package:quake/src/routes/settings.dart';
import 'package:quake/src/utils/connectivity.dart';

class Home extends StatelessWidget {
  /// Route name, used by [MaterialApp] to identify app's routes
  static const routeName = "/home";

  /// Contains the [AppBar]'s elevation
  static const double _kAppBarElevation = 2.0;

  /// BLoC of [HomePageScreenBase] used to make switching between screens
  /// on home easier.
  final HomePageScreenBloc homePageScreenBloc = HomePageScreenBloc();

  /// Contains the 3 different pages of the homepage
  final List<HomePageScreenBase> screens = [
    HomePageAll(),
    HomePageNearby(),
    HomePageMap(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _buildSystemUiOverlayTheme(context),
      child: QuakeStreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        initialData: QuakeConnectivityHelper().connectivity,
        builder: (context, connectionType) {
          // user is not connected to the internet return an error message
          if (connectionType == ConnectivityResult.none)
            return _handleNoConnection(context);
          else // user is connected
            return QuakeStreamBuilder<HomePageScreenBase>(
              stream: homePageScreenBloc.pageStream,
              initialData: screens[0],
              builder: (context, page) {
                return Scaffold(
                  appBar: _buildAppBar(context),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  bottomNavigationBar: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      _buildBottomNavigationBarItem(
                        icon: Icons.chrome_reader_mode,
                        text: QuakeLocalizations.of(context).all,
                      ),
                      _buildBottomNavigationBarItem(
                        icon: Icons.location_on,
                        text: QuakeLocalizations.of(context).nearby,
                      ),
                      _buildBottomNavigationBarItem(
                        icon: Icons.map,
                        text: QuakeLocalizations.of(context).map,
                      ),
                    ],
                    currentIndex: page.index,
                    onTap: (int index) =>
                        homePageScreenBloc.page = screens[index],
                  ),
                  body: page as Widget,
                );
              },
            );
        },
      ),
    );
  }

  /// Returns the widget that's being used when there's no connection,
  ///
  /// It has no content except for a very brief message at the center
  /// of the screen and the normal appbar with icons disabled.
  Scaffold _handleNoConnection(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, iconsEnabled: false),
      body: QuakeErrorWidget(
        message: QuakeLocalizations.of(context).noInternetConnection,
      ),
    );
  }

  /// Sets the color for the status bar and the navigation bar to match
  /// the opposite of the theme.
  SystemUiOverlayStyle _buildSystemUiOverlayTheme(BuildContext context) {
    return SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Theme.of(context).canvasColor,
      systemNavigationBarIconBrightness:
          Theme.of(context).brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
    );
  }

  /// Returns the standard [AppBar] styl for the app's main screens.
  ///
  /// When [iconsEnabled] is true the icons are clickable (used by [_handleNoConnection]).
  AppBar _buildAppBar(BuildContext context, {bool iconsEnabled = true}) {
    return AppBar(
      brightness: Theme.of(context)
          .brightness, // make status bar icons dark or light depending on the brightness
      centerTitle: Theme.of(context).platform ==
          TargetPlatform.iOS, // center title if running on ios
      primary: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            "assets/images/logo_with_bg.png",
            alignment: Alignment.centerRight,
          ),
          Text(QuakeLocalizations.of(context).title.substring(1)),
        ],
      ),
      textTheme: Theme.of(context).primaryTextTheme.copyWith(
            title: Theme.of(context)
                .primaryTextTheme
                .title
                .copyWith(letterSpacing: 3),
          ),
      elevation: _kAppBarElevation,
      actions: <Widget>[
        // IconButton(
        //   icon: Icon(Icons.search),
        //   onPressed: iconsEnabled ? () => _startSearchPage(context) : null,
        //   tooltip: QuakeLocalizations.of(context).searchTooltip,
        // ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: iconsEnabled
              ? () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => Settings(),
                      transitionsBuilder: (
                        BuildContext context,
                        Animation animation,
                        Animation secondaryAnimation,
                        Widget child,
                      ) =>
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset.zero,
                                end: Offset(1, 0),
                              ).animate(secondaryAnimation),
                              child: child,
                            ),
                          ),
                    ),
                  )
              : null,
          tooltip: QuakeLocalizations.of(context).settingsTooltip,
        ),
      ],
    );
  }

  void _startSearchPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SearchPage(),
        transitionsBuilder: (
          BuildContext context,
          Animation animation,
          Animation secondaryAnimation,
          Widget child,
        ) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(1, 0),
                ).animate(secondaryAnimation),
                child: child,
              ),
            ),
      ),
    );
  }

  /// Builds an item for the bottom navigation bar
  ///
  /// useful to not type Icon and Text everytime,
  /// this function can be removed safely by just wrapping [icon]
  /// and [text] with Icon() and Text() respectively.
  BottomNavigationBarItem _buildBottomNavigationBarItem({
    @required IconData icon,
    @required String text,
  }) =>
      BottomNavigationBarItem(
        icon: Icon(icon),
        title: Text(text),
      );
}
