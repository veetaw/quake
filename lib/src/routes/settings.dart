import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:meta/meta.dart';
import 'package:quake/src/themes/theme_provider.dart';
import 'package:package_info/package_info.dart';
import 'package:quake/src/utils/unit_of_measurement_conversion.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          SettingsSectionHeader(
            title: QuakeLocalizations.of(context).general,
          ),
          ListTile(
            title: Text(QuakeLocalizations.of(context).depthSettingsTile),
            leading: Icon(Icons.airplanemode_active),
            onTap: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => UnitOfMeasurementDialog(),
                ),
          ),
          SettingsSliderTile<double>(
            defaultValue: 20,
            minValue: 10,
            maxValue: 100,
            steps: 9,
            icon: Icons.airplanemode_active,
            sharedPreferencesKey: "nearbyRadiusKm",
            tileTitle: QuakeLocalizations.of(context).distanceMapSettingsTile,
          ),
          SettingsSliderTile<double>(
            defaultValue: 100,
            minValue: 10,
            maxValue: 500,
            steps: 500 ~/ 10 - 1,
            icon: Icons.airplanemode_active,
            sharedPreferencesKey: "earthquakesCount",
            tileTitle:
                QuakeLocalizations.of(context).earthquakesCountSettingsTile,
          ),
          SettingsSliderTile<double>(
            defaultValue: 2.5,
            minValue: 0,
            maxValue: 12,
            steps: 12,
            icon: Icons.airplanemode_active,
            sharedPreferencesKey: "minimumMagnitude",
            tileTitle: QuakeLocalizations.of(context).minMagnitudeSettingsTile,
          ),
          SettingsSectionHeader(
            title: QuakeLocalizations.of(context).notifications,
          ),
          ListTile(
            title:
                Text(QuakeLocalizations.of(context).notificationsSettingsTile),
            leading: Icon(Icons.directions_walk),
          ),
          SettingsSectionHeader(
            title: QuakeLocalizations.of(context).specialThanks,
          ),
          ListTile(
            title: Text(QuakeLocalizations.of(context).specialThanksTile),
            leading: Icon(Icons.train),
          ),
          SettingsSectionHeader(
            title: QuakeLocalizations.of(context).other,
          ),
          Card(
            elevation: 4.0,
            margin: EdgeInsets.all(8),
            child: Container(
              width: double.infinity,
              height: 150,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    QuakeLocalizations.of(context).githubTileTitle,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Text(
                    QuakeLocalizations.of(context).githubTileDescription,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => AboutDialog(),
                ),
            child: Container(
              width: double.infinity,
              height: 50,
              child: Center(
                child: FutureBuilder(
                    future: getAppVersion(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return Text("Quake ${snapshot.data}");
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  ListTile _buildChangeThemeTile(BuildContext context) {
    return ListTile(
      title: Text(QuakeLocalizations.of(context).chooseTheme),
      subtitle: Text(QuakeLocalizations.of(context).chooseThemeLong),
      leading: Icon(Icons.format_paint),
      onTap: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              ThemeProvider themeProvider = ThemeProvider();
              return Dialog(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  height: MediaQuery.of(context).size.height / 3,
                  child: ListView.builder(
                    itemCount: themeProvider.getAllThemes().length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 10,
                          backgroundColor: themeProvider
                              .getThemeByName(
                                themeProvider.getAllThemes()[index],
                              )
                              .accentColor,
                        ),
                        title: Text(
                          themeProvider.getAllThemes()[index],
                        ),
                        onTap: () => ThemeBloc().setTheme(
                              themeProvider.getThemeByName(
                                themeProvider.getAllThemes()[index],
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

class SettingsSliderTile<T> extends StatefulWidget {
  final String tileTitle;
  final IconData icon;
  final double minValue;
  final double maxValue;
  final double defaultValue;
  final int steps;
  final String sharedPreferencesKey;

  SettingsSliderTile({
    @required this.tileTitle,
    @required this.minValue,
    @required this.maxValue,
    @required this.defaultValue,
    @required this.icon,
    @required this.sharedPreferencesKey,
    @required this.steps,
    Key key,
  }) : super(key: key) {
    assert(T == double || T == int);
  }

  @override
  State<StatefulWidget> createState() => _SettingsSliderTileState<T>();
}

class _SettingsSliderTileState<T> extends State<SettingsSliderTile> {
  final bool isTypeDouble = T == double;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.tileTitle),
      leading: Icon(widget.icon),
      children: <Widget>[
        FutureBuilder<T>(
          future: _getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            T _savedValue = snapshot.data;
            return Container(
              height: 150,
              child: Slider(
                min: widget.minValue,
                value: isTypeDouble ? _savedValue : _savedValue as double,
                max: widget.maxValue,
                onChanged: (v) {
                  _saveData(v);
                  setState(() => _savedValue = v as T);
                },
                divisions: widget.steps,
                label: isTypeDouble
                    ? (_savedValue as double).ceil().toString()
                    : _savedValue.toString(),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<T> _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(widget.sharedPreferencesKey) ??
        widget.defaultValue as T;
  }

  void _saveData(double newValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isTypeDouble
        ? sharedPreferences.setDouble(widget.sharedPreferencesKey, newValue)
        : sharedPreferences.setInt(
            widget.sharedPreferencesKey, newValue.ceil());
  }
}

class UnitOfMeasurementDialog extends StatelessWidget {
  UnitOfMeasurementDialog({
    Key key,
  }) : super(key: key);
  final StreamController<int> valuesStream = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getUnitOfMeasurementFromSharedPrefs(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return StreamBuilder<int>(
          stream: valuesStream.stream,
          initialData: snapshot.data,
          builder: (context, snapshot) {
            return Dialog(
              elevation: 2,
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                child: ListView.builder(
                  itemCount: UnitOfMeasurement.values.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: index,
                      onChanged: _saveUnitOfMeasurementToSharedPrefs,
                      groupValue: snapshot.data,
                      title: Text(
                        QuakeLocalizations.of(context).unitOfMeasurement(
                          UnitOfMeasurement.values[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<int> _getUnitOfMeasurementFromSharedPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt("unitOfMeasurement") ?? 0;
  }

  void _saveUnitOfMeasurementToSharedPrefs(int value) async {
    valuesStream.sink.add(value);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("unitOfMeasurement", value);
  }

  void dispose() {
    valuesStream.close();
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
