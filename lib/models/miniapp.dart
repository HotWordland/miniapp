import 'package:miniapp/utils/value_util.dart';

/// 模型
class Miniapp {
  Miniapp.fromMap(Map json);
}

class MiniTag {

}

class ListRes {
  final List<Miniapp> data;
  final bool hasMore;

  ListRes.fromMap(Map json)
      : data = ValueUtil.toList(json['data'])
            .map((e) => Miniapp.fromMap(e))
            .toList(),
        hasMore = ValueUtil.toBool(json['has_more']);
}
