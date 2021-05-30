import 'package:flutter/material.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/router.dart';
import 'package:miniapp/views/index_list_card.dart';
import 'fav_viewmodel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        toolbarHeight: GetX.style.navbar_h,
        title: Text('我的收藏'),
        centerTitle: false,
      ),
      body: Container(
        child: _buildBody(),
        width: GetX.style.sw,
        height: double.infinity,
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<FavViewModel>(builder: (context, model, _) {
      if (model.items.isEmpty) {
        return ViewStateEmptyWidget(
          buttonText: Text("去搜索"),
          onPressed: () {
            GetX.router.push(RouterPath.search);
          },
        );
      }

      return ListView.builder(
        itemBuilder: (context, index) {
          final item = model.items[index];
          return Slidable(
            key: Key(item.id.toString()),
            child: IndexListCard(
              item,
              isFavList: true,
            ),
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: '取消收藏',
                color: Colors.red,
                icon: Icons.delete_outline,
                onTap: () {
                  model.delete(item);
                },
              ),
            ],
          );
        },
        itemCount: model.items.length,
      );
    });
  }
}
