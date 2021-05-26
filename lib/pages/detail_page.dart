import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/pages/detail_viewmodel.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:miniapp/pages/photo_view_page.dart';

class DetailPage extends StatelessWidget {
  final int id;
  final String name;

  DetailPage({required this.id, required this.name, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: GetX.style.navbar_h,
        brightness: Brightness.dark,
        title: Text(name),
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        create: (ctx) => DetailViewModel(id: id),
        builder: (ctx, child) => Consumer<DetailViewModel>(
          builder: (ctx, model, child) {
            if (model.isBusy) {
              return ViewStateBusyWidget();
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildInfo(ctx, model),
                  _buildDesc(ctx, model),
                  _buildScreens(ctx, model),
                  _buildScores(ctx, model),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScores(BuildContext context, DetailViewModel model) {
    return _section("小程序评分", child: Container());
  }

  Widget _buildScreens(BuildContext context, DetailViewModel model) {
    return _section(
      "小程序截图",
      child: Container(
        height: 400,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: GetX.style.tagBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Swiper(
          itemBuilder: (ctx, index) {
            final screen = model.item.screenshot[index];
            return Hero(
              tag: screen.id,
              child: CachedNetworkImage(
                imageUrl: screen.image,
                fit: BoxFit.fitHeight,
              ),
            );
          },
          itemCount: model.item.screenshot.length,
          pagination: SwiperPagination(),
          onTap: (int index) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewPage(
                  galleryItems: model.item.screenshot,
                  initialIndex: index,
                  scrollDirection: Axis.horizontal,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesc(BuildContext context, DetailViewModel model) {
    return _section(
      "小程序简介",
      child: Container(
        child: Text(
          model.item.description,
          style: TextStyle(
            fontSize: 16,
            height: 1.68,
          ),
        ),
      ),
    );
  }

  Widget _section(String title, {required Widget child}) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 30),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: GetX.style.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: GetX.style.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context, DetailViewModel model) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 16, right: 16),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: model.item.icon.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.item.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 5),
                    //   child: RatingBar.builder(
                    //     initialRating: model.item.overall_rating.toDouble(),
                    //     minRating: 0,
                    //     itemSize: 18,
                    //     direction: Axis.horizontal,
                    //     allowHalfRating: true,
                    //     ignoreGestures: true,
                    //     itemCount: 5,
                    //     unratedColor: Colors.grey[200],
                    //     itemPadding: EdgeInsets.only(right: 4),
                    //     itemBuilder: (context, index) => Icon(
                    //       Icons.star,
                    //       color: Colors.amber,
                    //     ),
                    //     onRatingUpdate: (rating) {},
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Wrap(
                        children: model.item.tag
                            .map((e) => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: GetX.style.tagBg,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    e.name,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: GetX.style.tagColor),
                                  ),
                                ))
                            .toList(),
                        spacing: 10,
                        runSpacing: 10,
                      ),
                    )
                  ],
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
