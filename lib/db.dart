import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DB {
  static final String hiveFavs = 'hive_favs';

  static setupDB() async {
    await Hive.initFlutter();

    /// 初始化表
    await Hive.openBox(hiveFavs);
  }

  static Box favsBox() {
    return Hive.box(hiveFavs);
  }
}
