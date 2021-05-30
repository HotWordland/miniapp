import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:like_button/like_button.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/models/miniapp.dart';
import 'package:miniapp/pages/detail_viewmodel.dart';
import 'package:miniapp/pages/fav_viewmodel.dart';
import 'package:miniapp/pages/photo_view_page.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as ImgCache;
import 'package:miniapp/router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class DetailPage extends StatelessWidget {
  final int id;
  final String name;

  DetailPage({required this.id, required this.name, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (ctx) => DetailViewModel(id: id),
        builder: (context, child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: GetX.style.navbar_h,
                brightness: Brightness.dark,
                title: Text(name),
                elevation: 0,
                actions: [
                  Consumer<DetailViewModel>(builder: (context, model, _) {
                    if (model.isBusy) {
                      return Container();
                    }
                    return IconButton(
                      onPressed: () {
                        _sharePop(context, model);
                      },
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    );
                  })
                ],
              ),
              body: Consumer<DetailViewModel>(
                builder: (ctx, model, child) {
                  if (model.isBusy) {
                    return ViewStateBusyWidget();
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildInfo(ctx, model),
                              _buildDesc(ctx, model),
                              _buildScreens(ctx, model),
                              SizedBox(height: 40)
                            ],
                          ),
                        ),
                      ),
                      _buildBottomBar(context, model),
                    ],
                  );
                },
              ),
            ));
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
        width: double.infinity,
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
      width: double.infinity,
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
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Wrap(
                        children: model.item.tag
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    GetX.router.push(RouterPath.tagApps,
                                        params: {'tag': e});
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
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

  Widget _buildBottomBar(BuildContext context, DetailViewModel model) {
    return Container(
      color: Colors.white,
      child: Container(
        height: GetX.style.navbar_h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildFav(context, model),
            Expanded(
                child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _showQR(context, model);
              },
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: GetX.style.primary,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '获取',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ))
          ],
        ),
      ),
      padding: EdgeInsets.only(
          bottom: GetX.style.safe_bottom_h, left: 16, right: 16),
    );
  }

  _showQR(BuildContext context, DetailViewModel model) {
    ImgCache.DefaultCacheManager()
        .getSingleFile(
      model.item.qrcode.image,
    )
        .then((File value) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              bottom: GetX.style.safe_bottom_h,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: model.item.qrcode.image,
                  width: GetX.style.sw * 0.5,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    '将二维码保存到相册中\n然后打开微信扫码',
                    style: TextStyle(
                      color: GetX.style.tagColor,
                      fontSize: 14,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    var status = await Permission.photos.request();
                    if (status.isDenied) {
                      showToast('请允许访问相册权限，不然无法保存图片');
                    } else {
                      await ImageGallerySaver.saveFile(value.path);
                      showToast('保存成功', onDismiss: () {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      decoration: BoxDecoration(
                        color: GetX.style.primary,
                      ),
                      child: Text(
                        '保存二维码',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildFav(BuildContext context, DetailViewModel model) {
    return Consumer<FavViewModel>(builder: (context, fav, _) {
      bool isFav = fav.isFav(model.item);

      return Container(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LikeButton(
              isLiked: isFav,
              size: 32,
              onTap: (isLike) {
                isLike ? fav.cancelFav(model.item) : fav.fav(model.item);
                return Future.value(!isLike);
              },
            ),
          ],
        ),
      );
    });
  }

  _sharePop(BuildContext context, DetailViewModel model) {
    showDialog(
        context: context,
        builder: (ctx) {
          return SharePopDialog(
            item: model.item,
          );
        });
  }
}

class SharePopDialog extends StatelessWidget {
  final Miniapp item;

  final ScreenshotController screenshotController = ScreenshotController();
  SharePopDialog({required this.item});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                child: Column(
                  children: [
                    if (item.screenshot.isNotEmpty)
                      Container(
                        color: Colors.grey[100],
                        child: CachedNetworkImage(
                          imageUrl: item.screenshot.first.image,
                          width: GetX.style.sw - 32,
                          height: GetX.style.sw - 32,
                          fit: BoxFit.contain,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: CachedNetworkImage(
                              imageUrl: item.qrcode.image,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final directory =
                          (await getApplicationDocumentsDirectory())
                              .path; //from path_provide package
                      String fileName =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      screenshotController
                          .captureAndSave(
                        directory,
                        fileName: fileName,
                      )
                          .then((value) {
                        if (value != null) {
                          Share.shareFiles([value], text: item.name);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: GetX.style.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '快乐分享',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: GetX.style.primary),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '保存相册',
                        style: TextStyle(
                          color: GetX.style.primary,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    ),
                    onTap: () {
                      screenshotController.capture().then((image) async {
                        var status = await Permission.photos.request();
                        if (status.isDenied) {
                          showToast('请允许访问相册权限，不然无法保存图片');
                        } else {
                          await ImageGallerySaver.saveImage(image!);
                          showToast('保存成功', onDismiss: () {
                            Navigator.of(context).pop();
                          });
                        }
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
