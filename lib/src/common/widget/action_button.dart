import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:quake/src/common/utils/string_utils.dart';
import 'package:quake/src/common/widget/platform_widget_base.dart';

typedef OnPressedAction = void Function();

/// Button that is going to be used for actions like accepting,
/// declining or moving back/forward.
/// Its text is going to be uppercase on Android and
/// capitalized on iOS.
class ActionButton extends PlatformWidgetBase<MaterialButton, CupertinoButton> {
  final String text;
  final OnPressedAction onPressed;
  final TextStyle textStyle;
  final Color color;

  final Key key;

  ActionButton({
    @required this.text,
    @required this.onPressed,
    this.textStyle,
    this.color,
    this.key,
  });

  @override
  CupertinoButton createAndroidWidget(BuildContext context) {
    return CupertinoButton(
      key: key,
      child: Text(
        text.toUpperCase(),
        style: textStyle,
      ),
      onPressed: onPressed,
      color: color,
    );
  }

  @override
  MaterialButton createIosWidget(BuildContext context) {
    return MaterialButton(
      key: key,
      child: Text(
        capitalizeAll(text),
        style: textStyle,
      ),
      onPressed: onPressed,
      color: color,
    );
  }
}
