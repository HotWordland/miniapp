import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'locator.dart';

/// 公共样式
class Style {
  /// 尺寸
  double get navbar_h => 44;
  double get statusbar_h => ScreenUtil().statusBarHeight;
  double get safe_bottom_h => ScreenUtil().bottomBarHeight;
  double get sw => 1.sw;
  double get sh => 1.sh;

  /// 颜色
  final Color primary = Colors.blue;
  final Color textPrimary = const Color(0xff333333);
  final Color tagBg = const Color(0xffF2F2F4);
  final Color tagColor = const Color(0xffB2B4B5);

  /// 图片
  Image image(String name, {double? width, double? height, BoxFit? fit}) {
    return Image.asset(
      'assets/images/$name',
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// 字体
}
