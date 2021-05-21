import 'package:flutter/cupertino.dart';

abstract class Config {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class DebugConfig extends Config {}

class ProductConfig extends Config {}

class PreviewConfig extends Config {}
