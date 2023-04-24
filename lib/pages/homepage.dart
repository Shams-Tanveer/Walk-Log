import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/walkingTypeController.dart';
import 'package:walk_log/pages/setLimitPage.dart';
import 'package:walk_log/pages/walkfinishingPage.dart';
import '../component/appName.dart';
import '../component/themeswitch.dart';
import 'homepage.dart';

class HomePage extends StatelessWidget {

  final WalkignTypeController _walkignTypeController = Get.put(WalkignTypeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
            top: 30,
            right: 20,
            child: ThemeSwitch()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.33),
                  child: Container(child: Center(child: AppName())),
                ),
                SizedBox(height: 48.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _walkignTypeController.updateWalkingType("outdoor");
                          Get.to(SetLimiPage());
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 23) * 0.50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/indoorwalking.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      GestureDetector(
                        onTap: () {
                          _walkignTypeController.updateWalkingType("indoor");
                          Get.to(SetLimiPage());
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 23) * 0.50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/outdoorwalking.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
