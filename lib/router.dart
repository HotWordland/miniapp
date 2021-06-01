import 'package:flutter/material.dart';
import 'package:miniapp/core/utils/value_util.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'pages/pages.dart';

enum RouterPath {
  root,
  unknown,
  detail,
  tagApps,
  search,
  featureDetail,
}

class Router {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    RouterPath path = settings.name?.routerPath ?? RouterPath.unknown;
    final Map arguments = ValueUtil.toMap(settings.arguments);
    switch (path) {
      case RouterPath.root:
        return MaterialPageRoute(
          builder: (context) => IndexPage(),
          settings: settings,
        );
      case RouterPath.detail:
        final int id = ValueUtil.toInt(arguments['id']);
        final String name = ValueUtil.toStr(arguments['name']);
        return MaterialPageRoute(
          builder: (context) => DetailPage(
            id: id,
            name: name,
          ),
          settings: settings,
        );
      case RouterPath.tagApps:
        final MiniTag tag = arguments['tag'] as MiniTag;
        return MaterialPageRoute(
          builder: (context) => TagAppsPage(tag: tag),
          settings: settings,
        );
      case RouterPath.search:
        return MaterialPageRoute(
          builder: (context) => SearchPage(),
          settings: settings,
        );
      case RouterPath.featureDetail:
        final MiniFeature feature = arguments['feature'] as MiniFeature;
        return MaterialPageRoute(
          builder: (context) => RankDetailPage(feature: feature),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => UnknownPage(name: settings.name),
          settings: settings,
        );
    }
  }

  Future<T?> push<T extends Object?>(RouterPath path,
      {BuildContext? context, Map<String, Object>? params}) {
    final ctx = context ?? GetX.config.navigatorKey.currentContext;
    if (ctx == null) return Future.value(null);
    return Navigator.of(ctx).pushNamed<T>(path.name, arguments: params);
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
