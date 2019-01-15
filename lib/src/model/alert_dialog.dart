import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:quake/src/locale/localizations.dart';

class QuakeAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onOkPressed;
  final VoidCallback onCancelPressed;

  QuakeAlertDialog({
    @required this.title,
    @required this.content,
    @required this.onOkPressed,
    this.onCancelPressed,
  });

  static Future createDialog(
    BuildContext context,
    QuakeAlertDialog dialog, {
    bool dismissible,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(QuakeLocalizations.of(context).locationPromptAlertTitle),
      content: Text(
        QuakeLocalizations.of(context).locationPromptAlertContent,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      actions: <Widget>[
        _buildButton(
          QuakeLocalizations.of(context).alertCancelButton,
          onCancelPressed ?? () => Navigator.of(context).pop(),
        ),
        _buildButton(
          QuakeLocalizations.of(context).alertOkButton,
          onOkPressed,
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return FlatButton(child: Text(text.toUpperCase()), onPressed: onPressed);
  }
}
