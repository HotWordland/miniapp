import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/pages/detail_viewmodel.dart';

class DetailPage extends StatelessWidget {
  final int id;
  final String name;

  DetailPage({required this.id, required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ],
              ),
            );
          },
        ),
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
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.item.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                      initialRating: model.item.overall_rating.toDouble(),
                      minRating: 0,
                      itemSize: 20,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.only(right: 4),
                      itemBuilder: (context, index) => Icon(
                        Icons.favorite,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
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
