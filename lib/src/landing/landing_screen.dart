import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:quake/src/common/widget/action_button.dart';

GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

class LandingScreen extends StatelessWidget {
  final PageController pageController = PageController();
  static const int kPageCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ChangeNotifierProvider<PageChangeNotifier>(
        builder: (_) => PageChangeNotifier(
          initialPage: 0,
          pageCount: kPageCount,
          controller: pageController,
        ),
        child: Builder(
          builder: (ctx) => Stack(
            children: <Widget>[
              PageView(
                key: Key("landing_slider"),
                controller: pageController,
                onPageChanged: (p) =>
                    Provider.of<PageChangeNotifier>(ctx).page = p,
                children: <Widget>[
                  Placeholder(),
                  Placeholder(),
                  Placeholder(),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                width: MediaQuery.of(context).size.width,
                child: ControlsRow(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class ControlsRow extends StatelessWidget {
  static const Curve kCurve = Curves.easeInOut;
  static const Duration kDuration = Duration(milliseconds: 250);
  static const double kDotHeight = 8;
  static const double kDotWidth = 8;
  static const double kActiveDotWidth = kDotWidth * 2.5;
  static const Color kDotColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final PageChangeNotifier notifier =
        Provider.of<PageChangeNotifier>(context);

    next() => notifier.controller.nextPage(
          curve: kCurve,
          duration: kDuration,
        );

    previous() => notifier.controller.previousPage(
          curve: kCurve,
          duration: kDuration,
        );

    finish() => null; /* TODO: */

    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: notifier.page == 0
              ? Container()
              : ActionButton(
                  key: Key("previous_button"),
                  text: "previous",
                  onPressed: previous,
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.body1.color,
                  ),
                ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              notifier.pageCount,
              (i) => _buildAnimatedDot(notifier, i),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: ActionButton(
            key: Key("next_button"),
            text: notifier.page == notifier.pageCount - 1 ? "finish" : "next",
            onPressed: notifier.page == notifier.pageCount - 1 ? finish : next,
            textStyle: TextStyle(
              color: Theme.of(context).textTheme.body1.color,
            ),
          ),
        ),
      ],
    );
  }

  AnimatedContainer _buildAnimatedDot(PageChangeNotifier notifier, int i) =>
      AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: kDotColor,
        ),
        duration: kDuration,
        height: kDotHeight,
        width: notifier.page == i ? kActiveDotWidth : kDotWidth,
      );
}

@visibleForTesting
class PageChangeNotifier extends ChangeNotifier {
  int _currentPage;
  final int pageCount;
  final PageController controller;

  PageChangeNotifier({
    @required int initialPage,
    @required this.controller,
    @required this.pageCount,
  }) : _currentPage = initialPage ?? 0;

  int get page => _currentPage;
  set page(int newPage) {
    if (newPage <= pageCount) _currentPage = newPage;

    notifyListeners();
  }
}
