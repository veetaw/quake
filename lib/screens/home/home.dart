import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CustomAppBar(),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key key,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isOpened = false;

  changeState() => setState(() => isOpened = !isOpened);
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double width = mediaQuery.size.width;
    final double height = mediaQuery.size.height;

    final bool isPortrait = mediaQuery.orientation == Orientation.portrait;

    final double _barHeight = isPortrait
        ? height / (isOpened ? 4 : 6)
        : height / (isOpened ? 2 : 2.5);

    final EdgeInsets _internalPadding = EdgeInsets.all(6);

    return SafeArea(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        width: width,
        height: _barHeight,
        color: Theme.of(context).cardColor,
        padding: _internalPadding,
        child: InkWell(
          onTap: changeState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Quake"),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ],
              ),
              if (isOpened)
                Row(
                  mainAxisAlignment: isPortrait
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "magnitude",
                    ),
                    Text("0.2"),
                    Text("-"),
                    Text("3.0"),
                  ],
                ),
              Row(
                children: <Widget>[
                  Container(
                    width: width / 8,
                    height: height / 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 6,
                    width: MediaQuery.of(context).size.width / 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                      color: Colors.grey[350],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text("Tap to expand"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
