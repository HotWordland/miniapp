import 'package:hive/hive.dart';
import 'package:miniapp/models/miniapp.dart';

abstract class FavDB {
  /// 获取我的收藏列表
  List<Miniapp> list();

  /// 我是否收藏
  bool isFav(Miniapp app);

  /// 取消收藏
  void delete(Miniapp app);

  /// 添加收藏
  void add(Miniapp app);
}

class FavDBImpl implements FavDB {
  final Box box;

  FavDBImpl(this.box);

  @override
  void add(Miniapp app) {
    box.put(app.id, app.toMap());
  }

  @override
  void delete(Miniapp app) {
    box.delete(app.id);
  }

  @override
  bool isFav(Miniapp app) {
    return box.containsKey(app.id);
  }

  @override
  List<Miniapp> list() {
    return box.values.map((e) => Miniapp.fromMap(e)).toList();
  }
}
