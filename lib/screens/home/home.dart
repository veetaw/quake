import 'package:flutter/material.dart';
import 'package:quake/screens/home/components/custom_app_bar.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CustomAppBar(),
          EarthquakeCard(),
        ],
      ),
    );
  }
}

class EarthquakeCard extends StatelessWidget {
  const EarthquakeCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    final cardHeight = height / 6;

    return Container(
      // height: cardHeight,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 26),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
              ),
              Text(
                "Date",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
              ),
              Text(
                "Time",
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.place),
                        Column(
                          children: [
                            Text(
                              "1.4",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              "km",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.place),
                        Column(
                          children: [
                            Text(
                              "1.4",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              "km",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
