import 'package:flutter/material.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'index_viewmodel.dart';

class IndexPage extends StatelessWidget {
  final PageController pageController = PageController();

  IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => IndexViewModel(),
      builder: (context, child) => Consumer<IndexViewModel>(
        builder: (context, model, child) => Scaffold(
          bottomNavigationBar: _tabbar(context, model),
          body: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) => model.items[index].page,
            controller: pageController,
            itemCount: model.items.length,
            onPageChanged: (index) => model.currentIndex = index,
          ),
        ),
      ),
    );
  }

  _tabbar(BuildContext context, IndexViewModel model) {
    return BottomNavigationBar(
      currentIndex: model.currentIndex,
      selectedItemColor: GetX.style.primary,
      unselectedItemColor: GetX.style.tagColor,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      elevation: 0,
      items: model.items
          .map((e) => BottomNavigationBarItem(
              label: e.name,
              icon: GetX.style.image(e.img, width: 24),
              activeIcon: GetX.style.image(e.imgSel, width: 24)))
          .toList(),
      onTap: (index) {
        pageController.jumpToPage(index);
      },
    );
  }
}
