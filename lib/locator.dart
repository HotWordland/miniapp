import 'package:miniapp/services/db/fav_db.dart';
import 'package:miniapp/services/repository/repository.dart';
import 'package:miniapp/style.dart';

import 'config.dart';
import 'router.dart';
import 'package:get_it/get_it.dart';
import 'db.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  // 设置配置环境
  locator.registerSingleton<Config>(DebugConfig());

  // 设置路由
  locator.registerLazySingleton<Router>(() => Router());

  // 设置样式
  locator.registerLazySingleton(() => Style());

  /// 设置网络请求
  locator.registerLazySingleton<Repository>(() => RepositoryImpl());

  /// 设置收藏
  locator.registerLazySingleton<FavDB>(() => FavDBImpl(DB.favsBox()));
}

/// 快捷获取
class GetX {
  static Config get config => locator<Config>();
  static Router get router => locator<Router>();
  static Style get style => locator<Style>();
  static Repository get repository => locator<Repository>();
  static FavDB get favDB => locator<FavDB>();
}
