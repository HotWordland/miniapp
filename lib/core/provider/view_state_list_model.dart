import 'view_state_model.dart';
import 'package:tuple/tuple.dart';

abstract class ViewStateListModel<T> extends ViewStateModel {
  List<T> list = [];

  initData() async {
    setBusy();
    await refresh(init: true);
  }

  /// 下拉刷新
  refresh({bool init = false}) async {
    try {
      final res = await loadData();
      var data = res.item1;
      if (data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        list.clear();
        list.addAll(data);
        setIdle();
      }
    } catch (e, s) {
      if (init) list.clear();
      setError(e, s);
    }
  }

  // 加载数据
  Future<Tuple2<List<T>, bool>> loadData();
}
