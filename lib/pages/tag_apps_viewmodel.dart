import 'package:miniapp/core/provider/view_state_refresh_list_model.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:tuple/tuple.dart';

class TagAppsViewModel extends ViewStateRefreshListModel {
  final MiniTag tag;

  TagAppsViewModel({required this.tag}) {
    initData();
  }

  @override
  Future<Tuple2<List, bool>> loadData({int pageNum = 1}) async {
    var res = await GetX.repository.getList(
      pageNo: pageNum,
      tag: tag.id,
      pageSize: pageSize,
    );
    return Tuple2(res.data, res.hasMore);
  }
}
