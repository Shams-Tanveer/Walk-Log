import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/themeController.dart';
import 'package:walk_log/pages/landingPage.dart';

import 'component/snackBar.dart';
import 'theme/thememanagement.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: SnackBarUtility.messengerKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeManagement.lightTheme,
      darkTheme: ThemeManagement.darkTheme,
      home: Scaffold(
        body: SafeArea(
          child: LandingPage()),
      ),
    );
  }
}