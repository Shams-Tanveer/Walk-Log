import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/backgrounddemo.dart';
import 'package:walk_log/checkingbackgroundor.dart';
import 'package:walk_log/pages/landingPage.dart';

import 'pages/historyPage.dart';
import 'pages/homepage.dart';
import 'theme/mytheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: Scaffold(
        body: SafeArea(child: HomePage()),
      ),
    );
  }
}