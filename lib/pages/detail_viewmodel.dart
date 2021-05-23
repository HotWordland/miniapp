import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';

class DetailViewModel extends ViewStateModel {
  late Miniapp _item;
  Miniapp get item => _item;

  DetailViewModel({required int id}) {
    loadDetail(id);
  }

  loadDetail(int id) async {
    setBusy();
    _item = await GetX.repository.getDetail(id);
    setIdle();
  }
}
