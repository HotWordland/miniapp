import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:tuple/tuple.dart';

class IndexViewModel extends ViewStateModel {
  List<MiniTag> _tags = [];

  List<MiniTag> get tags => _tags;

  IndexViewModel() {
    loadTags();
  }

  loadTags() async {
    setBusy();
    _tags = await GetX.repository.getTags();
    _tags.insert(0, MiniTag.newer());
    setIdle();
  }
}

class IndexChildViewModel extends ViewStateRefreshListModel {
  final MiniTag tag;

  IndexChildViewModel(this.tag) {
    initData();
  }

  @override
  Future<Tuple2<List<Miniapp>, bool>> loadData({int pageNum = 1}) async {
    var res = await GetX.repository.getList(
      pageNo: pageNum,
      tag: tag.isNewer ? null : tag.id,
      pageSize: pageSize,
    );
    return Tuple2(res.data, res.hasMore);
  }
}
