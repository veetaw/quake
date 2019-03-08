import 'package:flutter/material.dart';
import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:meta/meta.dart';
import 'package:quake/src/themes/theme_provider.dart';

class Settings extends StatelessWidget {
  static String routeName = "/settings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        primary: true,
        children: <Widget>[
          SettingsSectionHeader(
            title: QuakeLocalizations.of(context).appearance,
          ),
          _buildChangeThemeTile(context),
        ],
      ),
    );
  }

  ListTile _buildChangeThemeTile(BuildContext context) {
    return ListTile(
      title: Text(QuakeLocalizations.of(context).chooseTheme),
      subtitle: Text(QuakeLocalizations.of(context).chooseThemeLong),
      leading: Icon(Icons.format_paint), // TODO
      onTap: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              // TODO:
              ThemeProvider themeProvider = ThemeProvider();
              return Dialog(
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: GridView.builder(
                    itemCount: themeProvider.getAllThemes().length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(16),
                        child: InkWell(
                          onTap: () => ThemeBloc().setTheme(
                                themeProvider.getThemeByName(
                                  themeProvider.getAllThemes()[index],
                                ),
                              ),
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: themeProvider
                                .getThemeByName(
                                  themeProvider.getAllThemes()[index],
                                )
                                .accentColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      brightness: Theme.of(context)
          .brightness, // make status bar icons dark or light depending on the brightness
      centerTitle: Theme.of(context).platform ==
          TargetPlatform.iOS, // center title if running on ios
      primary: true,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      elevation: 2,
      title: Text(
        QuakeLocalizations.of(context).settings,
      ),
    );
  }
}

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  const SettingsSectionHeader({
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: double.infinity,
      child: Text(
        title,
        maxLines: 1,
        style: Theme.of(context)
            .textTheme
            .subhead
            .copyWith(color: Theme.of(context).accentColor),
      ),
    );
  }
}
