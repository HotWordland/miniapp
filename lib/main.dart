import 'package:flutter/material.dart';
import 'router.dart';
import 'locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        title: 'miniapp',
        debugShowCheckedModeBanner: false,
        navigatorKey: GetX.config.navigatorKey,
        theme: ThemeData.light(),
        initialRoute: RouterPath.root.name,
        onGenerateRoute: GetX.router.onGenerateRoute,
      ),
    );
  }
}
