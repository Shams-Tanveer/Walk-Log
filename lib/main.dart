import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/backgrounddemo.dart';
import 'package:walk_log/checkingbackgroundor.dart';
import 'package:walk_log/fourcard.dart';
import 'package:walk_log/pages/landingPage.dart';
import 'package:walk_log/pages/userInfo.dart';
import 'package:walk_log/pages/walkfinishingPage.dart';
import 'package:walk_log/pedometerImp.dart';

import 'component/snackBar.dart';
import 'pages/historyPage.dart';
import 'pages/homepage.dart';
import 'theme/mytheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: SnackBarUtility.messengerKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: Scaffold(
        body: SafeArea(child: LandingPage()),
      ),
    );
  }
}