import 'package:flutter/material.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:miniapp/views/index_list_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'index_viewmodel.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => IndexViewModel(),
      builder: (ctx, child) => Scaffold(
        body: Consumer<IndexViewModel>(
          builder: (ctx, model, child) {
            if (model.isBusy) {
              return ViewStateBusyWidget();
            }
            return _buildContent(context, model);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, IndexViewModel model) {
    return DefaultTabController(
      length: model.tags.length,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: _sliverAppBar(innerBoxIsScrolled, model),
            ),
          ];
        },
        body: _buildBody(context, model),
      ),
    );
  }

  Widget _buildBody(BuildContext context, IndexViewModel model) {
    return TabBarView(
      children: model.tags.map((e) {
        return IndexChildPage(e);
      }).toList(),
    );
  }

  PreferredSize _tabbar(IndexViewModel model) {
    var tabbar = TabBar(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2,
          color: Colors.white,
        ),
        insets: EdgeInsets.only(left: 0, right: 20, bottom: 4),
      ),
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      labelPadding: EdgeInsets.only(left: 0, right: 0),
      tabs: model.tags
          .map((e) => Padding(
                padding: EdgeInsets.only(right: 20),
                child: Tab(
                  child: Text(
                    e.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
          .toList(),
    );

    return PreferredSize(
      preferredSize: tabbar.preferredSize,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: GetX.style.sw,
        child: tabbar,
        color: GetX.style.primary,
      ),
    );
  }

  SliverAppBar _sliverAppBar(bool innerBoxIsScrolled, IndexViewModel model) {
    final tabbar = _tabbar(model);
    return SliverAppBar(
      title: Text(
        "小程序",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: false,
      brightness: Brightness.dark,
      backgroundColor: GetX.style.primary,
      toolbarHeight: GetX.style.navbar_h,
      pinned: true, // 标题栏是否固定
      floating: false, // 滑动是否悬浮
      snap: false, // 配合 floating 使用
      primary: true, // 是否显示在状态栏的下面,false就会占领状态栏的高度
      elevation: 0,
      forceElevated: innerBoxIsScrolled,
      expandedHeight: 80 +
          tabbar.preferredSize.height +
          GetX.style.statusbar_h +
          GetX.style
              .navbar_h, // 合并的高度，默认是状态栏的高度 + appbar 的高度，表示flexibleSpace的高度
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
            child: Stack(
          children: [
            WaveWidget(
              config: CustomConfig(
                colors: [
                  Colors.white70,
                  Colors.white54,
                  Colors.white38,
                ],
                durations: [30000, 20000, 10000],
                heightPercentages: [0.64, 0.67, 0.70],
                blur: MaskFilter.blur(BlurStyle.outer, 16),
              ),
              waveAmplitude: 0,
              backgroundColor: GetX.style.primary,
              size: Size(GetX.style.sw, double.infinity),
            ),
            Positioned(
              bottom: tabbar.preferredSize.height + 45,
              child: _searchBar(),
            )
          ],
        )),
      ),
      bottom: tabbar,
    );
  }

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 36,
      width: GetX.style.sw - 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.blue,
            size: 18,
          ),
          SizedBox(width: 2),
          Text(
            '搜索小程序',
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }
}

class IndexChildPage extends StatefulWidget {
  final MiniTag tag;

  IndexChildPage(this.tag, {Key? key}) : super(key: key);

  @override
  _IndexChildPageState createState() => _IndexChildPageState();
}

class _IndexChildPageState extends State<IndexChildPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (ctx) => IndexChildViewModel(widget.tag),
      builder: (context, child) {
        return Consumer<IndexChildViewModel>(builder: (context, model, child) {
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
    );
  }

  Widget _buildList(BuildContext context, IndexChildViewModel model) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
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
