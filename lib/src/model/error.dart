import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ErrorWidget extends StatelessWidget {
  final String message;
  final double size;

  ErrorWidget({@required this.message, this.size}) : assert(message != null);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: Theme.of(context).iconTheme.color,
            size: size ?? Theme.of(context).iconTheme.size,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
