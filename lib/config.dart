import 'package:flutter/cupertino.dart';

abstract class Config {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final String baseUrl =
      "https://3e905290-75ce-4dea-856f-13a281f673f3.bspapp.com/http/";
}

class DebugConfig extends Config {}

class ProductConfig extends Config {}

class PreviewConfig extends Config {}
