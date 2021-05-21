import 'package:flutter/material.dart';
import 'package:miniapp/style.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key? key}) : super(key: key);

  final List<String> tabs = ["1", "2", "4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: _sliverAppBar(innerBoxIsScrolled),
              ),
            ];
          },
          body: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(
      children: tabs.map((e) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (context) {
              return CustomScrollView(
                key: PageStorageKey<String>(e),
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(10.0),
                    sliver: SliverFixedExtentList(
                      itemExtent: 50,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ListTile(
                            title: Text('Item $index'),
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      }).toList(),
    );
  }

  PreferredSize _tabbar() {
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
      tabs: tabs
          .map((e) => Padding(
                padding: EdgeInsets.only(right: 20),
                child: Tab(
                  child: Text(
                    'Tab $e',
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
        width: style.sw,
        child: tabbar,
        color: Colors.blue,
      ),
    );
  }

  SliverAppBar _sliverAppBar(bool innerBoxIsScrolled) {
    var tabbar = _tabbar();

    return SliverAppBar(
      title: Text(
        "小应用",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: false,
      brightness: Brightness.dark,
      backgroundColor: Colors.blue,
      toolbarHeight: style.navbar_h,
      pinned: true, // 标题栏是否固定
      floating: false, // 滑动是否悬浮
      snap: false, // 配合 floating 使用
      primary: true, // 是否显示在状态栏的下面,false就会占领状态栏的高度
      elevation: 0,
      forceElevated: innerBoxIsScrolled,
      expandedHeight: 80 +
          tabbar.preferredSize.height +
          style.statusbar_h +
          style.navbar_h, // 合并的高度，默认是状态栏的高度 + appbar 的高度，表示flexibleSpace的高度
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
              backgroundColor: Colors.blue,
              size: Size(style.sw, double.infinity),
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
      width: style.sw - 60,
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
            '搜索小应用',
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }
}
