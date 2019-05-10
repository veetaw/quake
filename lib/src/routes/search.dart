// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:quake/src/bloc/earthquakes_bloc.dart';

// import 'package:quake/src/locale/localizations.dart';
// import 'package:quake/src/model/earthquake.dart';
// import 'package:quake/src/model/earthquake_card.dart';
// import 'package:quake/src/model/quake_builders.dart';
// import 'package:quake/src/routes/earthquakes_list.dart';
// import 'package:rxdart/rxdart.dart';

// typedef void OnChangedCallback(int newValue);
// enum AppState { loading, done }
// EarthquakesBloc earthquakesBloc = EarthquakesBloc();

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   DateTime startDate = DateTime.now().subtract(Duration(days: 7));
//   DateTime endDate = DateTime.now();
//   TextEditingController textEditingController = TextEditingController();
//   int minDepth = 0;
//   int maxDepth = 1200;
//   int minMagnitude = 0;
//   int maxMagnitude = 12;

//   bool advanced = false;

//   List<Earthquake> results = [];
//   AppState state = AppState.done;
//   ScrollController scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     // if user set maxValue to a values smaller than minValue set maxValue to minValue
//     minDepth = minDepth >= maxDepth ? maxDepth : minDepth;
//     minMagnitude = minMagnitude >= maxMagnitude ? maxMagnitude : minMagnitude;

//     ListView listView = ListView(
//       padding: const EdgeInsets.only(top: 8),
//       controller: scrollController,
//       children: <Widget>[
//         _buildSearchTiles(context),
//       ]..add(state == AppState.done
//           ? Container()
//           : state == AppState.loading
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : EarthquakesList(
//                   stream: earthquakesBloc.searchedEarthquakes,
//                   onRefresh: () {},
//                 )),
//     );

//     return Scaffold(
//       appBar: _buildAppBar(context),
//       resizeToAvoidBottomInset: false,
//       body: listView,
//     );
//   }

//   Column _buildSearchTiles(BuildContext context) {
//     return Column(
//       key: Key('tiles'),
//       children: <Widget>[
//         _buildSearchBox(),
//         ExpansionTile(
//           title: Text(QuakeLocalizations.of(context).advancedSearch),
//           initiallyExpanded: false,
//           onExpansionChanged: (v) => advanced = v,
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 _buildDatePicker(context, false),
//                 _buildDatePicker(context, true),
//                 Row(
//                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     _buildPicker(
//                       QuakeLocalizations.of(context).minDepth,
//                       minDepth >= maxDepth ? maxDepth : minDepth,
//                       (newValue) => setState(() => minDepth = newValue),
//                       generator: (i) => i > maxDepth / 100 ? null : i * 100,
//                     ),
//                     _buildPicker(
//                       QuakeLocalizations.of(context).maxDepth,
//                       maxDepth,
//                       (newValue) => setState(() => maxDepth = newValue),
//                       generator: (i) => i * 100,
//                     ),
//                   ],
//                 ),
//                 Row(
//                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     _buildPicker(
//                         QuakeLocalizations.of(context).minMagnitude,
//                         minMagnitude,
//                         (newValue) => setState(() => minMagnitude = newValue)),
//                     _buildPicker(
//                         QuakeLocalizations.of(context).maxMagnitude,
//                         maxMagnitude,
//                         (newValue) => setState(() => maxMagnitude = newValue)),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: OutlineButton(
//               child: Text(
//                 QuakeLocalizations.of(context).searchTooltip,
//                 style: TextStyle(fontSize: 16),
//               ),
//               onPressed: () async {
//                 results = [];
//                 state = AppState.loading;
//                 SearchOptions searchOption = SearchOptions(
//                   startTime: startDate,
//                   endTime: endDate,
//                   maxDepth: maxDepth,
//                   minDepth: minDepth,
//                   maxMagnitude: maxMagnitude,
//                   minMagnitude: minMagnitude,
//                 );
//                 setState(() => state = AppState.loading);
//                 earthquakesBloc.search(options: searchOption, force: true);
//               },
//               borderSide: BorderSide(color: Colors.white.withOpacity(0)),
//               disabledBorderColor: Colors.white.withOpacity(0),
//               highlightedBorderColor: Colors.white.withOpacity(0),
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildPicker(String text, int value, OnChangedCallback onChanged,
//       {Function(int) generator}) {
//     if (generator == null) generator = (i) => i;
//     return Padding(
//       padding: EdgeInsets.all(8),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width / 2 - 8 * 2,
//         height: 50,
//         child: Container(
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             border: Border.all(color: _getColor(Theme.of(context))),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Text(
//                 text,
//                 style: TextStyle(fontSize: 16),
//               ),
//               DropdownButton<int>(
//                 onChanged: onChanged,
//                 value: value,
//                 items: List<DropdownMenuItem<int>>.generate(13, (i) {
//                   i = generator(i);
//                   return i != null
//                       ? DropdownMenuItem<int>(
//                           child: Text(i.toString()),
//                           value: i,
//                         )
//                       : null;
//                 }).where((v) => v != null).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// from input_decorator.dart
//   Color _getColor(ThemeData theme) {
//     switch (theme.brightness) {
//       case Brightness.dark:
//         return Colors.white70;
//       case Brightness.light:
//         return Colors.black45;
//       default:
//         return theme.iconTheme.color;
//     }
//   }

//   Widget _buildSearchBox() {
//     final OutlineInputBorder border = OutlineInputBorder(
//       borderSide: BorderSide(color: _getColor(Theme.of(context))),
//       borderRadius: BorderRadius.circular(8),
//     );
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: textEditingController,
//         decoration: InputDecoration(
//           border: border,
//           labelText: QuakeLocalizations.of(context).searchBoxLabel,
//           prefixIcon: Icon(Icons.location_on),
//           isDense: true,
//           disabledBorder: border,
//           enabledBorder: border,
//           focusedBorder: border,
//         ),
//       ),
//     );
//   }

//   Widget _buildDatePicker(BuildContext context, bool end) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: 50,
//         child: Container(
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             border: Border.all(color: _getColor(Theme.of(context))),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: GestureDetector(
//             onTap: () => showDatePicker(
//                         context: context,
//                         initialDate: end ? endDate : startDate,
//                         firstDate: end ? startDate : DateTime(1970, 1, 1),
//                         lastDate: end ? DateTime.now() : endDate,
//                         locale: Locale(QuakeLocalizations.localeCode))
//                     .then((d) {
//                   setState(() {
//                     if (d == null) return;
//                     if (end)
//                       endDate = d;
//                     else
//                       startDate = d;
//                   });
//                 }),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(
//                   width: 48,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(
//                       Icons.date_range,
//                       color: _getColor(Theme.of(context)),
//                       size: 18,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   DateFormat.yMMMMd()
//                       .format(end ? endDate : startDate)
//                       .toString(),
//                   style: TextStyle(fontSize: 16),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       brightness: Theme.of(context)
//           .brightness, // make status bar icons dark or light depending on the brightness
//       centerTitle: Theme.of(context).platform ==
//           TargetPlatform.iOS, // center title if running on ios
//       automaticallyImplyLeading: true,
//       elevation: 2,
//       title: Text(QuakeLocalizations.of(context).search),
//     );
//   }
// }
