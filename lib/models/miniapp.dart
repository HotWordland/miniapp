import 'package:miniapp/core/utils/value_util.dart';

class MiniIcon {
  final String created_at;
  final int id;
  final String image;
  MiniIcon.fromMap(Map json)
      : created_at = ValueUtil.toStr(json['created_at']),
        image = ValueUtil.toStr(json['image']),
        id = ValueUtil.toInt(json['id']);
}

class MiniTag {
  final int id;
  final String name;

  MiniTag.fromMap(Map json)
      : id = ValueUtil.toInt(json['id']),
        name = ValueUtil.toStr(json['name']);
}

/// 模型
class Miniapp {
  final String? announcement;
  final int created_at;
  final String created_by;
  final String description;
  final String? developer_message;
  final MiniIcon icon;
  final int id;
  final bool is_poi;
  final bool is_recommended;
  final List<String> label;
  final int overall_rating;
  final MiniIcon qrcode;
  final List<int> rating;
  final String? recommendation_reason;
  final String? recommended_at;
  final String release_status;
  final String reputation;
  final String? reservation_success_tip;
  final List<MiniIcon> screenshot;
  final List<MiniTag> tag;
  final String? url;
  final String? video_url;
  final int visit_amount;

  Miniapp.fromMap(Map json)
      : announcement = json['announcement'],
        created_by = ValueUtil.toStr(json['created_by']),
        description = ValueUtil.toStr(json['description']),
        developer_message = json['developer_message'],
        icon = MiniIcon.fromMap(json['icon']),
        id = ValueUtil.toInt(json['id']),
        is_poi = ValueUtil.toBool(json['is_poi']),
        is_recommended = ValueUtil.toBool(json['is_recommended']),
        label = ValueUtil.toList(json['label']).map((e) => ValueUtil.toStr(e)).toList(),
        overall_rating = ValueUtil.toInt(json['overall_rating']),
        qrcode = MiniIcon.fromMap(json['qrcode']),
        rating = ValueUtil.toList(json['rating']).map((e) => ValueUtil.toInt(e)).toList(),
        recommendation_reason = json['recommendation_reason'],
        recommended_at = json['recommended_at'],
        release_status = ValueUtil.toStr(json['release_status']),
        reputation = ValueUtil.toStr(json['reputation']),
        reservation_success_tip = json['reservation_success_tip'],
        screenshot = ValueUtil.toList(json['screenshot']).map((e) => MiniIcon.fromMap(e)).toList(),
        tag = ValueUtil.toList(json['tag']).map((e) => MiniTag.fromMap(e)).toList(),
        url = json['url'],
        video_url = json['video_url'],
        visit_amount = ValueUtil.toInt(json['visit_amount']),
        created_at = ValueUtil.toInt(json['created_at']);
}

class ListRes {
  final List<Miniapp> data;
  final bool hasMore;

  ListRes.fromMap(Map json)
      : data = ValueUtil.toList(json['data']).map((e) => Miniapp.fromMap(e)).toList(),
        hasMore = ValueUtil.toBool(json['has_more']);
}
