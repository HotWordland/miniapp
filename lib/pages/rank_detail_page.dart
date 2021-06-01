import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:miniapp/views/index_list_card.dart';
import 'rank_detail_viewmodel.dart';

class RankDetailPage extends StatelessWidget {
  final MiniFeature feature;

  const RankDetailPage({Key? key, required this.feature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
      create: (ctx) => RankDetailViewModel(feature.id),
      builder: (context, _) =>
          Consumer(builder: (context, RankDetailViewModel model, child) {
        if (model.isBusy) {
          return ViewStateBusyWidget();
        }
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              brightness: Brightness.dark,
              elevation: 0,
              pinned: false,
              snap: false,
              floating: true,
              primary: true,
              expandedHeight: 180,
              toolbarHeight: GetX.style.navbar_h,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: feature.bgimage,
                      width: double.infinity,
                      height: double.infinity,
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
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    feature.title,
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(blurRadius: 5),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    feature.summary,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return IndexListCard(model.feature.apps[index]);
              }, childCount: model.feature.apps.length),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: GetX.style.safe_bottom_h),
            )
          ],
        );
      }),
    ));
  }
}
