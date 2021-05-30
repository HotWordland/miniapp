import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';

class FavViewModel extends ViewStateModel {
  List<Miniapp> items = [];

  final favDB = GetX.favDB;

  FavViewModel() {
    loadData(notify: false);
  }

  loadData({bool notify = true}) {
    items = favDB.list();
    setIdle();
  }

  delete(Miniapp app) {
    items.remove(app);
    favDB.delete(app);
    setIdle();
  }

  fav(Miniapp app) {
    items.add(app);
    favDB.add(app);
    setIdle();
  }

  cancelFav(Miniapp miniapp) {
    items.removeWhere((element) => element.id == miniapp.id);
    favDB.delete(miniapp);
    setIdle();
  }

  bool isFav(Miniapp miniapp) {
    return items.indexWhere((element) => element.id == miniapp.id) >= 0;
  }
}
