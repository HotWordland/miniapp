import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';

class RankViewModel extends ViewStateModel {
  List<MiniFeature> _features = [];
  List<MiniFeature> get features => _features;

  RankViewModel() {
    loadData();
  }

  loadData() async {
    setBusy();
    _features = await GetX.repository.getFutures();
    setIdle();
  }
}
