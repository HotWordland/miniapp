import 'package:hive/hive.dart';
import 'package:miniapp/core/provider/view_state_refresh_list_model.dart';
import 'package:miniapp/core/utils/value_util.dart';
import 'package:miniapp/db.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:tuple/tuple.dart';

class SearchViewModel extends ViewStateRefreshListModel {
  bool _showSearchResult = false;

  Box get _box => DB.searchHisBox();

  bool get showSearchResult => _showSearchResult;

  set showSearchResult(bool state) {
    _showSearchResult = state;
    setIdle();
  }

  String? _searchText;

  set searchText(String text) {
    _searchText = text;
    _showSearchResult = true;
    initData();
    _saveHis(text);
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

  List<String> getSearHistory() {
    return _box.values.map((e) => ValueUtil.toStr(e)).toList();
  }

  clearHistory() {
    _box.clear();
    setIdle();
  }

  _saveHis(String text) {
    if (text.isNotEmpty && !_box.values.contains(text)) {
      _box.add(text);
    }
  }
}
