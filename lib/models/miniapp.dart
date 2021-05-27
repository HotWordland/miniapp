import 'package:miniapp/core/utils/value_util.dart';

class MiniIcon {
  final String created_at;
  final int id;
  final String image;
  MiniIcon.fromMap(Map json)
      : created_at = ValueUtil.toStr(json['created_at']),
        image = ValueUtil.toStr(json['image']),
        id = ValueUtil.toInt(json['id']);

  Map toMap() {
    return {'created_at': created_at, 'image': image, 'id': id};
  }
}

class MiniTag {
  final int id;
  final String name;

  MiniTag.newer()
      : id = 1008611,
        name = '最新';

  bool get isNewer => id == 1008611 && name == '最新';

  MiniTag.fromMap(Map json)
      : id = ValueUtil.toInt(json['id']),
        name = ValueUtil.toStr(json['name']);

  Map toMap() {
    return {'id': id, 'name': name};
  }
}

/// 模型
class Miniapp {
  final String? announcement;
  final int created_at;
  final String name;
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
        label = ValueUtil.toList(json['label'])
            .map((e) => ValueUtil.toStr(e))
            .toList(),
        overall_rating = ValueUtil.toInt(json['overall_rating']),
        qrcode = MiniIcon.fromMap(json['qrcode']),
        rating = ValueUtil.toList(json['rating'])
            .map((e) => ValueUtil.toInt(e))
            .toList(),
        recommendation_reason = json['recommendation_reason'],
        recommended_at = json['recommended_at'],
        release_status = ValueUtil.toStr(json['release_status']),
        reputation = ValueUtil.toStr(json['reputation']),
        reservation_success_tip = json['reservation_success_tip'],
        screenshot = ValueUtil.toList(json['screenshot'])
            .map((e) => MiniIcon.fromMap(e))
            .toList(),
        tag = ValueUtil.toList(json['tag'])
            .map((e) => MiniTag.fromMap(e))
            .toList(),
        url = json['url'],
        video_url = json['video_url'],
        visit_amount = ValueUtil.toInt(json['visit_amount']),
        created_at = ValueUtil.toInt(json['created_at']),
        name = ValueUtil.toStr(json['name']);

  Map toMap() {
    return {
      "announcement": announcement,
      "created_by": created_by,
      "description": description,
      "developer_message": developer_message,
      "icon": icon.toMap(),
      "id": id,
      "is_poi": is_poi,
      "is_recommended": is_recommended,
      "label": label,
      "overall_rating": overall_rating,
      "qrcode": qrcode.toMap(),
      "rating": rating,
      "recommendation_reason": recommendation_reason,
      "recommended_at": recommended_at,
      "release_status": release_status,
      "reputation": reputation,
      "reservation_success_tip": reservation_success_tip,
      "screenshot": screenshot.map((e) => e.toMap()).toList(),
      "tag": tag.map((e) => e.toMap()).toList(),
      "url": url,
      "video_url": video_url,
      "visit_amount": visit_amount,
      "created_at": created_at,
      "name": name,
    };
  }
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
