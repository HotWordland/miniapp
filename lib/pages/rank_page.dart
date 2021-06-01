import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:miniapp/router.dart';
import 'rank_viewmodel.dart';
import 'package:auto_animated/auto_animated.dart';

class RankPage extends StatefulWidget {
  const RankPage({Key? key}) : super(key: key);

  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: GetX.style.navbar_h,
        title: Text('专题'),
        elevation: 0,
        centerTitle: false,
        brightness: Brightness.dark,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => RankViewModel(),
      builder: (ctx, _) =>
          Consumer<RankViewModel>(builder: (context, model, child) {
        if (model.isBusy) {
          return ViewStateBusyWidget();
        }
        return LiveList(
            showItemInterval: Duration(milliseconds: 150),
            showItemDuration: Duration(milliseconds: 350),
            reAnimateOnVisibility: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index, animate) {
              var item = model.features[index];
              return FadeTransition(
                opacity: Tween<double>(begin: 0.4, end: 1).animate(animate),
                child: SlideTransition(
                  position:
                      Tween<Offset>(begin: Offset(0, -0.1), end: Offset.zero)
                          .animate(animate),
                  child: _featureCell(item),
                ),
              );
            },
            itemCount: model.features.length);
      }),
    );
  }

  Widget _featureCell(MiniFeature item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        GetX.router.push(RouterPath.featureDetail, params: {'feature': item});
      },
      child: Container(
        height: 200,
        width: double.infinity,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: item.bgimage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
                child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 15,
                  sigmaY: 10,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: Text(
                    item.title,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 10)]),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
