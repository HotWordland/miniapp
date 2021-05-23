import 'package:tuple/tuple.dart';

import 'view_state_list_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class ViewStateRefreshListModel<T> extends ViewStateListModel<T> {
  /// 分页第一页页码
  static const int pageNumFirst = 1;

  /// 分页条目数量
  int pageSize = 20;

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;

  /// 当前页码
  int _currentPageNum = pageNumFirst;

  /// 下拉刷新
  refresh({bool init = false}) async {
    try {
      _currentPageNum = pageNumFirst;
      final res = await loadData(pageNum: pageNumFirst);
      var data = res.item1;
      if (data.isEmpty) {
        refreshController.refreshCompleted(resetFooterState: true);
        list.clear();
        setEmpty();
      } else {
        list.clear();
        list.addAll(data);
        refreshController.refreshCompleted();
        if (res.item2) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
        setIdle();
      }
    } catch (e, s) {
      if (init) list.clear();
      refreshController.refreshFailed();
      setError(e, s);
    }
  }

  /// 上拉加载更多
  loadMore() async {
    try {
      final res = await loadData(pageNum: ++_currentPageNum);
      var data = res.item1;
      if (data.isEmpty) {
        _currentPageNum -= 1;
        refreshController.loadNoData();
      } else {
        list.addAll(data);
        if (res.item2) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
        notifyListeners();
      }
      return data;
    } catch (e, _) {
      _currentPageNum -= 1;
      refreshController.loadFailed();
    }
  }

  // 加载数据, bool 是否有下一页
  Future<Tuple2<List<T>, bool>> loadData({int pageNum});

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
