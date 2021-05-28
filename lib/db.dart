import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DB {
  static final String hiveFavs = 'hive_favs';
  static final String hivSearchHis = 'hiv_search_his';

  static setupDB() async {
    await Hive.initFlutter();

    /// 初始化表
    await Hive.openBox(hiveFavs);
    await Hive.openBox(hivSearchHis);
  }

  static Box favsBox() {
    return Hive.box(hiveFavs);
  }

  static Box searchHisBox() {
    return Hive.box(hivSearchHis);
  }
}
