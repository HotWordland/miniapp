import 'package:flutter/material.dart';
import 'package:miniapp/locator.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: GetX.style.navbar_h,
        elevation: 0,
        brightness: Brightness.dark,
      ),
    );
  }
}
