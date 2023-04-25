import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/component/appName.dart';
import 'package:walk_log/component/themeswitch.dart';
import 'package:walk_log/pages/setLimitPage.dart';
import 'package:walk_log/pages/homePage.dart';
import '../component/customButton.dart';
import '../component/snackBar.dart';

class WalkFinishPage extends StatelessWidget {
  double target;

  WalkFinishPage({Key? key, required this.target});

  Future<bool> _onWillPop() async {
    SnackBarUtility.showSnackBar("You Cannot Get Back to Previous Screen.");
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Positioned(top: 30, right: 20, child: ThemeSwitch()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: AppName()),
                    Image.asset(
                      'assets/images/walk_complete.png',
                      width: double.infinity,
                      height: 220,
                      color: Colors.greenAccent.shade700,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Congratulations!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              fontFamily: "Comic"),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "You have",
                          style: TextStyle(fontSize: 24, fontFamily: "Comic"),
                        )
                      ],
                    ),
                    Text(
                      'walked for ${target.toInt().toString()} meters',
                      style: TextStyle(fontSize: 24, fontFamily: "Comic"),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your hard work and determination have paid off. Remember, every finish line is the beginning of a new race. Keep pushing yourself to achieve even greater things!',
                      style: TextStyle(fontSize: 16, fontFamily: "Lato"),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    MyButton(
                      text: "Go To Home",
                      onPressed: () {
                        Get.offAll(() => HomePage());
                      },
                      fromLeft: Colors.greenAccent,
                      toRight: Colors.greenAccent.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
