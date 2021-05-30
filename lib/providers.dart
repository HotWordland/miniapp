import 'package:miniapp/pages/fav_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders() {
  return [
    ChangeNotifierProvider(create: (ctx) => FavViewModel()),
  ];
}
