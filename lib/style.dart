import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'locator.dart';

/// 公共样式
class Style {
  /// 尺寸
  double get navbar_h => 44;
  double get statusbar_h => ScreenUtil().statusBarHeight;
  double get bottombar_h => ScreenUtil().bottomBarHeight;
  double get sw => 1.sw;
  double get sh => 1.sh;

  /// 颜色

  /// 图片

  /// 字体
}

extension WidgetExt on Widget {
  Style get style => GetX.style;
}
