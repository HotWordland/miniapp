import 'package:miniapp/core/provider/view_state_refresh_list_model.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:tuple/tuple.dart';

class SearchViewModel extends ViewStateRefreshListModel {
  bool _searchState = false;

  bool get searchState => _searchState;

  set searchState(bool state) {
    _searchState = state;
    setIdle();
  }

  String? _searchText;

  set searchText(String text) {
    _searchText = text;
    _searchState = true;
    initData();
  }

  @override
  Future<Tuple2<List<Miniapp>, bool>> loadData({int pageNum = 1}) async {
    var res = await GetX.repository.getList(
      pageNo: pageNum,
      pageSize: pageSize,
      searchText: _searchText,
    );
    return Tuple2(res.data, res.hasMore);
  }
}
