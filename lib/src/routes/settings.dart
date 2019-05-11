import 'dart:async';

import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';
import 'package:quake/src/bloc/earthquakes_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:quake/src/bloc/theme_bloc.dart';
import 'package:quake/src/locale/localizations.dart';
import 'package:quake/src/themes/theme_provider.dart';
import 'package:quake/src/utils/unit_of_measurement_conversion.dart';
import 'package:quake/src/model/quake_builders.dart';
import 'package:quake/src/utils/map_url.dart';
import 'package:quake/src/utils/quake_shared_preferences.dart';

final QuakeSharedPreferences quakeSharedPreferences = QuakeSharedPreferences();
final Map<String, String> contributors = {
  "Vito (dev)": "https://github.com/veetaw",
  "Eskilop (icon design)": "https://www.eskilop.it",
  "Alessio": "https://github.com/AlecsFerra",
  "Giorgio": "https://github.com/giorgioshine",
};

class Settings extends StatelessWidget {
  static String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
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
            leading: Icon(Icons.arrow_downward),
            onTap: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => UnitOfMeasurementDialog(),
                ),
          ),
          ListTile(
            title: Text(QuakeLocalizations.of(context).sourceSettingsTile),
            leading: Icon(Icons.adjust),
            onTap: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => SourceDialog(),
                ),
          ),
          ListTile(
            title: Text(QuakeLocalizations.of(context).mapProviderSettingsTile),
            leading: Icon(Icons.map),
            onTap: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => MapProviderDialog(),
                ),
          ),
          SettingsSectionHeader(
            title: QuakeLocalizations.of(context).notifications,
          ),
          NotitificationsEnabledTile(),
          SettingsSectionHeader(
            title: QuakeLocalizations.of(context).specialThanks,
          ),
          _buildContributorsTile(context),
          SettingsSectionHeader(
            title: QuakeLocalizations.of(context).other,
          ),
          Card(
            elevation: 4.0,
            margin: EdgeInsets.all(8),
            child: Container(
              width: double.infinity,
              height: 200,
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
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: <Widget>[
                      MaterialButton(
                        child: Text("Issue Tracker"),
                        onPressed: () async {
                          const String issueTrackerUrl =
                              "https://github.com/veetaw/quake/issues";
                          if (await canLaunch(issueTrackerUrl))
                            await launch(issueTrackerUrl);
                        },
                      ),
                      MaterialButton(
                        child: Text("Github"),
                        onPressed: () async {
                          const String url = "https://github.com/veetaw/quake";
                          if (await canLaunch(url)) await launch(url);
                        },
                      ),
                    ],
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

  ListTile _buildContributorsTile(BuildContext context) {
    return ListTile(
      title: Text(QuakeLocalizations.of(context).specialThanksTile),
      leading: Icon(Icons.people),
      onTap: () => showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => QuakeDialog(
                  title: QuakeLocalizations.of(context).specialThanksTile,
                  child: ListView.builder(
                    itemCount: contributors.keys.length,
                    itemBuilder: (context, index) {
                      String key = contributors.keys.toList()[index];
                      return ListTile(
                        title: Text(key),
                        leading: Icon(Icons.person),
                        onTap: () async {
                          if (await canLaunch(contributors[key]))
                            await launch(contributors[key]);
                        },
                      );
                    },
                  ),
                ),
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
              List supportedThemes = themeProvider.getAllThemes();
              return QuakeDialog(
                title: QuakeLocalizations.of(context).chooseTheme,
                child: ListView.builder(
                  itemCount: supportedThemes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor: themeProvider
                              .getThemeByName(
                                supportedThemes[index],
                              )
                              .accentColor,
                        ),
                        title: Text(
                          QuakeLocalizations.of(context)
                              .theme(supportedThemes[index]),
                        ),
                        onTap: () {
                          ThemeBloc().theme = themeProvider.getThemeByName(
                            supportedThemes[index],
                          );
                          Navigator.of(context).pop();
                        });
                  },
                ),
              );
            },
          ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      brightness: Theme.of(context)
          .brightness, // make status bar icons dark or light depending on the brightness
      centerTitle: Theme.of(context).platform ==
          TargetPlatform.iOS, // center title if running on ios
      primary: true,
      elevation: 2,
      title: Text(
        QuakeLocalizations.of(context).settings,
      ),
    );
  }
}

class NotitificationsEnabledTile extends StatelessWidget {
  final StreamController notificationsEnabledController =
      StreamController<bool>.broadcast();
  final StreamController nearEnabledController =
      StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return QuakeStreamBuilder<bool>(
        stream: notificationsEnabledController.stream,
        initialData: quakeSharedPreferences.getValue<bool>(
            key: QuakeSharedPreferencesKey.notificationsEnabled,
            defaultValue: false),
        builder: (context, notificationsEnabled) {
          bool nearSwitchEnabled = quakeSharedPreferences.getValue<bool>(
                key: QuakeSharedPreferencesKey.hasLocationSaved,
                defaultValue: false,
              ) &&
              notificationsEnabled;
          return Column(
            children: <Widget>[
              SwitchListTile(
                title: Text(
                  QuakeLocalizations.of(context).notificationsSettingsTile,
                ),
                secondary: Icon(Icons.notifications),
                value: notificationsEnabled,
                onChanged: (newValue) {
                  quakeSharedPreferences.setValue<bool>(
                    key: QuakeSharedPreferencesKey.notificationsEnabled,
                    value: newValue,
                  );

                  if (!newValue) {
                    quakeSharedPreferences.setValue<bool>(
                      key: QuakeSharedPreferencesKey
                          .onlyNearNotificationsEnabled,
                      value: newValue,
                    );
                    nearEnabledController.sink.add(newValue);
                  }

                  notificationsEnabledController.sink.add(newValue);
                },
              ),
              QuakeStreamBuilder<bool>(
                  stream: nearEnabledController.stream,
                  initialData: nearSwitchEnabled,
                  builder: (context, onlyNear) {
                    return SwitchListTile(
                      title: Text(
                        QuakeLocalizations.of(context)
                            .nearNotificationsSettingsTile,
                      ),
                      subtitle: Text(
                        QuakeLocalizations.of(context)
                            .nearNotificationsSettingsTileSubtitle,
                      ),
                      secondary: Icon(Icons.my_location),
                      value: onlyNear,
                      onChanged: nearSwitchEnabled
                          ? (newValue) {
                              quakeSharedPreferences.setValue<bool>(
                                key: QuakeSharedPreferencesKey
                                    .onlyNearNotificationsEnabled,
                                value: newValue,
                              );
                              nearEnabledController.sink.add(newValue);
                            }
                          : null,
                    );
                  }),
            ],
          );
        });
  }

  void dispose() {
    notificationsEnabledController.close();
  }
}

class MapProviderDialog extends StatelessWidget {
  MapProviderDialog({
    Key key,
  }) : super(key: key);

  final StreamController<int> valuesStream = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return QuakeStreamBuilder<int>(
      stream: valuesStream.stream,
      initialData: _getCurrentProvider().index,
      builder: (context, data) {
        return QuakeDialog(
          title: QuakeLocalizations.of(context).mapProviderSettingsTile,
          child: ListView.builder(
            itemCount: UnitOfMeasurement.values.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: index,
                onChanged: (v) {
                  _saveProvider(v);
                  Navigator.of(context).pop();
                },
                groupValue: data,
                title: Text(
                  QuakeLocalizations.of(context)
                      .mapProvider(MapStyles.values[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  MapStyles _getCurrentProvider() {
    String rawTemplateEnumString = quakeSharedPreferences.getValue<String>(
      key: QuakeSharedPreferencesKey.mapTilesProvider,
      defaultValue: MapStyles.base.toString(),
    );

    return getMapStyleByString(rawTemplateEnumString);
  }

  void _saveProvider(int value) {
    valuesStream.sink.add(value);
    quakeSharedPreferences.setValue<String>(
      key: QuakeSharedPreferencesKey.mapTilesProvider,
      value: MapStyles.values[value].toString(),
    );
  }

  void dispose() {
    valuesStream.close();
  }
}

class UnitOfMeasurementDialog extends StatelessWidget {
  UnitOfMeasurementDialog({
    Key key,
  }) : super(key: key);

  final StreamController<int> valuesStream = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return QuakeStreamBuilder<int>(
      stream: valuesStream.stream,
      initialData: _getUnitOfMeasurementFromSharedPrefs().index,
      builder: (context, data) {
        return QuakeDialog(
          title: QuakeLocalizations.of(context).depthSettingsTile,
          child: ListView.builder(
            itemCount: UnitOfMeasurement.values.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: index,
                onChanged: (v) {
                  _saveUnitOfMeasurementToSharedPrefs(v);
                  Navigator.of(context).pop();
                },
                groupValue: data,
                title: Text(
                  QuakeLocalizations.of(context).unitOfMeasurement(
                    UnitOfMeasurement.values[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  UnitOfMeasurement _getUnitOfMeasurementFromSharedPrefs() {
    var _rawStr = quakeSharedPreferences.getValue<String>(
      key: QuakeSharedPreferencesKey.unitOfMeasurement,
      defaultValue: UnitOfMeasurement.kilometers.toString(),
    );
    return UnitOfMeasurementConversion.unitOfMeasurementFromString(_rawStr);
  }

  void _saveUnitOfMeasurementToSharedPrefs(int value) {
    valuesStream.sink.add(value);
    quakeSharedPreferences.setValue<String>(
      key: QuakeSharedPreferencesKey.unitOfMeasurement,
      value: UnitOfMeasurement.values[value].toString(),
    );
  }

  void dispose() {
    valuesStream.close();
  }
}

class SourceDialog extends StatelessWidget {
  SourceDialog({
    Key key,
  }) : super(key: key);

  final StreamController<int> valuesStream = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return QuakeStreamBuilder<int>(
      stream: valuesStream.stream,
      initialData: _getSourceFromSharedPrefs().index,
      builder: (context, data) {
        return QuakeDialog(
          title: QuakeLocalizations.of(context).sourceSettingsTile,
          child: ListView.builder(
            itemCount: EarthquakesListSource.values.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: index,
                onChanged: (v) {
                  _saveSourceToSharedPrefs(v);
                  // force the bloc to fetch earthquakes again with the new source
                  quakeSharedPreferences.setValue(
                      key: QuakeSharedPreferencesKey.lastEarthquakesFetch,
                      value: 0);
                  Navigator.of(context).pop();
                },
                groupValue: data,
                title: Text(
                  QuakeLocalizations.of(context).source(
                    EarthquakesListSource.values[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  EarthquakesListSource _getSourceFromSharedPrefs() {
    String rawSource = quakeSharedPreferences.getValue<String>(
      key: QuakeSharedPreferencesKey.earthquakesSource,
      defaultValue: EarthquakesListSource.ingv.toString(),
    );
    return EarthquakesListSource.values
        .singleWhere((s) => s.toString() == rawSource);
  }

  void _saveSourceToSharedPrefs(int value) {
    valuesStream.sink.add(value);
    quakeSharedPreferences.setValue<String>(
      key: QuakeSharedPreferencesKey.earthquakesSource,
      value: EarthquakesListSource.values
          .singleWhere((s) => s.index == value)
          .toString(),
    );
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

class QuakeDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const QuakeDialog({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 4,
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3 - 50,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
