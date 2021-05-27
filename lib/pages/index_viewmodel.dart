import 'package:flutter/cupertino.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'home_page.dart';
import 'fav_page.dart';

class TabItem {
  final String name;
  final String img;
  final String imgSel;
  final Widget page;

  TabItem({
    required this.name,
    required this.img,
    required this.imgSel,
    required this.page,
  });
}

class IndexViewModel extends ViewStateModel {
  final List<TabItem> items = [
    TabItem(
        name: "首页",
        img: "tab_home.png",
        imgSel: "tab_home_sel.png",
        page: HomePage()),
    TabItem(
        name: "收藏",
        img: "tab_fav.png",
        imgSel: "tab_fav_sel.png",
        page: FavPage()),
  ];

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    print("$index");
    _currentIndex = index;
    notifyListeners();
  }
}
