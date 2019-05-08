// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:meta/meta.dart';
// import 'package:flare_flutter/flare_actor.dart';
// import 'package:quake/src/model/quake_builders.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:quake/src/app.dart';
// import 'package:quake/src/locale/localizations.dart';

// class LandingPage extends StatefulWidget {
//   @override
//   _LandingPageState createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
//   /// Animation curve for page switching.
//   static const Curve _kCurve = Curves.ease;

//   /// Duration of the animation while switching pages.
//   static const Duration _kDuration = Duration(milliseconds: 300);

//   /// Used to control page switching etc, for more infos see [PageController].
//   final PageController _controller = PageController();

//   /// Streamcontroller for the current page index.
//   ///
//   /// For the future, maybe use a BLoC.
//   final StreamController pageStreamController = StreamController<int>();

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _pages = <Widget>[
//       _LandingPageScreen(
//         title: QuakeLocalizations.of(context).welcomeTitle,
//         description: QuakeLocalizations.of(context).welcomeDescription,
//         animationPath: "assets/flare/earth.flr",
//         animationName: "Untitled",
//         backgroundColor: _IntroTheme._kWelcomeBackgroundColor,
//       ),
//     ];

//     return Scaffold(
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.dark.copyWith(
//           systemNavigationBarColor: Theme.of(context).canvasColor,
//           systemNavigationBarIconBrightness: Brightness.dark,
//         ),
//         child: QuakeStreamBuilder<int>(
//             stream: pageStreamController.stream,
//             initialData: 0,
//             builder: (context, _page) {
//               return Stack(
//                 children: <Widget>[
//                   PageView.builder(
//                     itemCount: _pages.length,
//                     controller: _controller,
//                     onPageChanged: pageStreamController.sink.add,
//                     itemBuilder: (BuildContext context, int page) =>
//                         _pages[page % _pages.length],
//                   ),
//                   Positioned(
//                     bottom: 0.0,
//                     left: 0.0,
//                     right: 0.0,
//                     child: Container(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Center(
//                         child: DotsRow(
//                           controller: _controller,
//                           itemCount: _pages.length,
//                           dotMaxZoom: 1.5,
//                           dotSize: 5.0,
//                           dotSpacing: 15.0,
//                           color: _IntroTheme._kDotColor,
//                           leading: _page == 0
//                               ? _buildMaterialButton(
//                                   title: QuakeLocalizations.of(context).skip,
//                                   pages: _pages,
//                                   onPressed: () => _controller.animateToPage(
//                                         // skip button logic
//                                         _pages.length - 1,
//                                         curve: _kCurve,
//                                         duration: _kDuration,
//                                       ),
//                                 )
//                               : MaterialButton(
//                                   onPressed: null,
//                                 ), // blank button as placeholder
//                           trailing: _buildMaterialButton(
//                             title: _page != _pages.length - 1
//                                 ? QuakeLocalizations.of(context).next
//                                 : QuakeLocalizations.of(context).finish,
//                             pages: _pages,
//                             onPressed: () => _page != _pages.length - 1
//                                 ? _controller.nextPage(
//                                     // next / start button logic
//                                     curve: _kCurve,
//                                     duration: _kDuration,
//                                   )
//                                 : _closeLandingPage(context),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }),
//       ),
//     );
//   }

//   void _closeLandingPage(BuildContext context) async {
//     // set firstTime var to false so the next time the main will not launch landing page
//     (await SharedPreferences.getInstance()).setBool("firstTime", false);
//     Navigator.of(context).pushReplacementNamed(Home.routeName);
//   }

//   /// util to build the two bottom buttons
//   MaterialButton _buildMaterialButton({
//     @required String title,
//     @required List<Widget> pages,
//     @required VoidCallback onPressed,
//   }) =>
//       MaterialButton(
//         child: Text(
//           title.toUpperCase(),
//           style: TextStyle(
//             color: _IntroTheme._kTextcolor,
//             fontFamily: _IntroTheme._kFontFamily,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         onPressed: onPressed,
//       );

//   @override
//   void dispose() {
//     pageStreamController.close();
//     super.dispose();
//   }
// }

// /// This represents a page of the initial introuction to the app
// ///
// /// params:
// /// [backgroundColor] : page background color
// /// [title] : brief title, max one line
// /// [description] : brief description max 3 lines
// /// [animationPath] : Flare animation path
// /// [animationName] : Flare animation name
// class _LandingPageScreen extends StatelessWidget {
//   final Color backgroundColor;
//   final String title;
//   final String description;
//   final String animationPath;
//   final String animationName;

//   _LandingPageScreen({
//     @required this.backgroundColor,
//     @required this.title,
//     @required this.description,
//     @required this.animationPath,
//     @required this.animationName,
//   });

//   @override
//   Widget build(BuildContext context) => ConstrainedBox(
//         constraints: BoxConstraints.expand(),
//         child: Container(
//           color: backgroundColor,
//           child: Column(
//             children: <Widget>[
//               Expanded(
//                 child: Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(40.0),
//                     child: FlareActor(
//                       animationPath,
//                       animation: animationName,
//                       alignment: Alignment.bottomCenter,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Text(
//                           title,
//                           maxLines: 1,
//                           overflow: TextOverflow
//                               .clip, // title should *never* overflow
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: _IntroTheme._kTextcolor,
//                             fontFamily: _IntroTheme._kFontFamily,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 22.0,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: 8.0),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Text(
//                           description,
//                           maxLines: 4,
//                           overflow: TextOverflow.clip,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: _IntroTheme._kTextcolor,
//                             fontFamily: _IntroTheme._kFontFamily,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 20.0,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
// }

// /// dots row model
// /// inspired from https://gist.github.com/collinjackson/4fddbfa2830ea3ac033e34622f278824
// ///
// /// @params:
// /// [controller] : a PageController, used to check the actual index of the page
// /// [itemCount] : how many dots should be created and displayed
// /// [dotSize] : dot radius
// /// [dotMaxZoom] : how many times should be increased the dot when "active"
// /// [dotSpacing] : the space between dots
// /// [color] : dots' color
// /// [leading] : the button positioned at the left
// /// [trailing] : the button positioned at the right
// class DotsRow extends AnimatedWidget {
//   final PageController controller;
//   final int itemCount;
//   final double dotSize;
//   final double dotMaxZoom;
//   final double dotSpacing;
//   final Color color;

//   final MaterialButton leading;
//   final MaterialButton trailing;

//   DotsRow({
//     @required this.controller,
//     @required this.itemCount,
//     @required this.dotSize,
//     @required this.dotMaxZoom,
//     @required this.dotSpacing,
//     @required this.leading,
//     @required this.trailing,
//     this.color: Colors.white,
//   }) : super(listenable: controller);

//   /// builds a dingle dot
//   Widget _buildDot(int index) {
//     double _selectedZoom = Curves.easeOut.transform(
//       max(
//         0.0,
//         1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
//       ),
//     );
//     double zoom = 1.0 + (dotMaxZoom - 1.0) * _selectedZoom;
//     return Container(
//       width: dotSpacing,
//       child: Center(
//         child: Material(
//           color: color,
//           type: MaterialType.circle,
//           child: Container(
//             width: dotSize * zoom,
//             height: dotSize * zoom,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget build(BuildContext context) => Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           leading,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List<Widget>.generate(itemCount, _buildDot),
//           ),
//           trailing,
//         ],
//       );
// }

// /// This should not depend on theme.
// class _IntroTheme {
//   static const Color _kDotColor = Color(0xFF000000);
//   static const Color _kTextcolor = Color(0xFF000000);
//   static const String _kFontFamily = "Montserrat";
//   static const Color _kWelcomeBackgroundColor = Color(0xFFc8e6c9);
//   static const Color _kAppStatusBackgroundColor = Color(0xFFFFFFFF);
// }
