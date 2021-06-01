import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';

class RankDetailViewModel extends ViewStateModel {
  String _featureId;

  late MiniFeature _feature;
  MiniFeature get feature => _feature;

  RankDetailViewModel(String featureId) : _featureId = featureId {
    loadData();
  }

  loadData() async {
    setBusy();
    _feature = await GetX.repository.getFutureDetail(_featureId);
    setIdle();
  }
}
