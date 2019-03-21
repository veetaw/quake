import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class QuakeErrorWidget extends StatelessWidget {
  final String message;
  final double size;
  final IconData icon;

  QuakeErrorWidget({@required this.message, this.size, this.icon})
      : assert(message != null);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon ?? Icons.warning,
            color: Theme.of(context).iconTheme.color,
            size: size ?? Theme.of(context).iconTheme.size,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
