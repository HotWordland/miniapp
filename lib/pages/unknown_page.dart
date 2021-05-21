import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  final String? name;
  UnknownPage({this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("不支持页面：$name"),
        ),
      ),
    );
  }
}
