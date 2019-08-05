import 'package:flutter/widgets.dart';
import 'dart:io' show Platform;

/// Base class for platform aware widgets.
/// 
/// from: https://medium.com/flutter/do-flutter-apps-dream-of-platform-aware-widgets-7d7ed7b4624d
/// This could be easily extended to support desktop and web, too.
abstract class PlatformWidgetBase<I extends Widget,A extends Widget> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid) {
      return createAndroidWidget(context);
    } else if (Platform.isIOS) {
      return createIosWidget(context);
    }
    return new Container();
  }

  I createIosWidget(BuildContext context);
  A createAndroidWidget(BuildContext context);
}
