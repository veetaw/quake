import 'package:flutter/material.dart';

import 'package:quake/models/earthquake.dart';
import 'package:quake/screens/details/details_preview.dart';

class EarthquakeCard extends StatelessWidget {
  final Earthquake earthquake;

  const EarthquakeCard({
    @required this.earthquake,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              barrierDismissible: true,
              opaque: false,
              pageBuilder: (context, _, __) => DetailsPreview(
                earthquake: earthquake,
              ),
            ),
          );
        },
        child: Hero(
          tag: earthquake,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  earthquake.eventName,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 26),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                ),
                Text(
                  "${earthquake.time.month}/${earthquake.time.year}", //TODO
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                ),
                Text(
                  "${earthquake.time.hour}:${earthquake.time.second}", //TODO,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 18),
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
                                earthquake.magnitude.toString(),
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              Text(
                                "richter",
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
                                earthquake.depth.toString(),
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
      ),
    );
  }
}
