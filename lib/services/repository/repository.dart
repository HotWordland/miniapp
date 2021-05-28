import 'package:dio/dio.dart';
import 'package:miniapp/core/utils/value_util.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';

abstract class Repository {
  Future<ListRes> getList(
      {int pageSize = 10, int pageNo = 1, int? tag, String? searchText});
  Future<Miniapp> getDetail(int id);
  Future<List<MiniTag>> getTags();
}

class RepositoryImpl extends Repository {
  late Dio _dio;

  RepositoryImpl() {
    BaseOptions options = BaseOptions(baseUrl: GetX.config.baseUrl);
    _dio = Dio(options);
  }

  Future<ListRes> getList(
      {int pageSize = 10, int pageNo = 1, int? tag, String? searchText}) async {
    final res = await _dio.get('question/miniapp/list', queryParameters: {
      "page_size": pageSize,
      "page_no": pageNo,
      "tag": tag,
      "searchText": searchText,
    });
    return ListRes.fromMap(res.data);
  }

  Future<Miniapp> getDetail(int id) async {
    final res =
        await _dio.get('question/miniapp/detail', queryParameters: {"id": id});
    return Miniapp.fromMap(res.data);
  }

  Future<List<MiniTag>> getTags() async {
    final res = await _dio.get('question/miniapp/tags');

    return Future.value(
        ValueUtil.toList(res.data).map((e) => MiniTag.fromMap(e)).toList());
  }
}
