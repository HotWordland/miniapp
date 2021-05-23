import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:miniapp/router.dart';
import 'package:miniapp/style.dart';

class IndexListCard extends StatelessWidget {
  final Miniapp item;
  IndexListCard(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        GetX.router.push(RouterPath.detail, params: {
          "id": item.id,
          "name": item.name,
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 30),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: item.icon.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: GetX.style.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xff666666), fontSize: 12),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
