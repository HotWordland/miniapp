import 'package:flutter/material.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:miniapp/views/index_list_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'tag_apps_viewmodel.dart';

class TagAppsPage extends StatelessWidget {
  final MiniTag tag;

  const TagAppsPage({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: GetX.style.navbar_h,
        title: Text('#${tag.name}'),
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        create: (ctx) => TagAppsViewModel(tag: tag),
        builder: (context, child) {
          return Consumer<TagAppsViewModel>(builder: (context, model, child) {
            if (model.isBusy) {
              return ViewStateBusyWidget();
            }
            if (model.isEmpty) {
              return ViewStateEmptyWidget(
                buttonText: Text('重新加载'),
                onPressed: () {
                  model.initData();
                },
              );
            }
            if (model.isError) {
              return ViewStateErrorWidget(
                error: model.viewStateError!,
                buttonText: Text('重新加载'),
                onPressed: () {
                  model.initData();
                },
              );
            }
            return SmartRefresher(
              controller: model.refreshController,
              enablePullUp: true,
              enablePullDown: false,
              child: _buildList(context, model),
              onRefresh: () => model.refresh(),
              onLoading: () => model.loadMore(),
            );
          });
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, TagAppsViewModel model) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, index) {
              final Miniapp item = model.list[index];
              return _buildListCard(item);
            },
            childCount: model.list.length,
          ),
        ),
      ],
    );
  }

  _buildListCard(Miniapp item) {
    return IndexListCard(item);
  }
}
