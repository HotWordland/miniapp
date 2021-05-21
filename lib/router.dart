import 'package:flutter/material.dart';
import 'pages/pages.dart';

enum RouterPath {
  root,
  unknown,
}

class Router {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    RouterPath path = settings.name?.routerPath ?? RouterPath.unknown;
    switch (path) {
      case RouterPath.root:
        return MaterialPageRoute(
          builder: (context) => IndexPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => UnknownPage(name: settings.name),
          settings: settings,
        );
    }
  }
}

extension RouterPathExt on RouterPath {
  String get name {
    if (this == RouterPath.root) {
      return "/";
    }
    return this.toString().split(".").last;
  }
}

extension RoterPathStr on String {
  RouterPath get routerPath {
    if (this == "/") {
      return RouterPath.root;
    }
    int index = RouterPath.values.indexWhere((element) => element.name == this);
    return index >= 0 ? RouterPath.values[index] : RouterPath.unknown;
  }
}
