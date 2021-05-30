import 'package:flutter/material.dart';
import 'package:miniapp/core/provider/provider.dart';
import 'package:miniapp/locator.dart';
import 'package:miniapp/views/index_list_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'search_viewmodel.dart';

class SearchPage extends StatelessWidget {
  final textController = TextEditingController();

  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => SearchViewModel(),
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: GetX.style.navbar_h,
            elevation: 0,
            brightness: Brightness.dark,
            title: _searchField(context),
          ),
          body: Container(
            child: _buildBody(context),
            width: GetX.style.sw,
            height: double.infinity,
          ),
        );
      },
    );
  }

  Widget _searchField(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.only(right: 5),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Focus(
              child: TextField(
                controller: textController,
                textInputAction: TextInputAction.search,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '小程序名称',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  context.read<SearchViewModel>().showSearchResult = false;
                } else {
                  context.read<SearchViewModel>().searchText =
                      textController.text;
                }
              },
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<SearchViewModel>(builder: (context, model, child) {
      if (model.showSearchResult) {
        return Container(
          child: _buildResult(context, model),
          width: GetX.style.sw,
          height: double.infinity,
        );
      } else {
        return _buildPlaceholder(context, model);
      }
    });
  }

  Widget _buildPlaceholder(BuildContext context, SearchViewModel model) {
    List<String> his = model.getSearHistory();

    return Container(
      width: GetX.style.sw,
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (his.isNotEmpty)
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '搜索历史',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        model.clearHistory();
                      },
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            his.isNotEmpty
                ? Container(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: his
                          .map((e) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  textController.text = e;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: GetX.style.tagBg,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      color: GetX.style.tagColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  )
                : Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 100),
                    child: Text(
                      '暂无搜索历史',
                      style: TextStyle(
                        fontSize: 16,
                        color: GetX.style.tagColor,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, SearchViewModel model) {
    if (model.isBusy) {
      return ViewStateBusyWidget();
    }
    if (model.isEmpty) {
      return ViewStateEmptyWidget(
        buttonText: Text('重新加载'),
        onPressed: () {
          model.initData();
        },
      );
    }
    if (model.isError) {
      return ViewStateErrorWidget(
        error: model.viewStateError!,
        buttonText: Text('重新加载'),
        onPressed: () {
          model.initData();
        },
      );
    }
    return SmartRefresher(
      controller: model.refreshController,
      enablePullUp: true,
      enablePullDown: false,
      child: _buildList(context, model),
      onRefresh: () => model.refresh(),
      onLoading: () => model.loadMore(),
    );
  }

  Widget _buildList(BuildContext context, SearchViewModel model) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, index) => IndexListCard(model.list[index]),
            childCount: model.list.length,
          ),
        ),
      ],
    );
  }
}
