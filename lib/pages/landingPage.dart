import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:walk_log/component/themeswitch.dart';
import 'package:walk_log/controller/themeController.dart';
import 'package:walk_log/pages/setLimitPage.dart';
import 'package:walk_log/pages/userInfo.dart';
import 'package:walk_log/security/securityClass.dart';

import '../component/customButton.dart';
import 'homepage.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}): super(key: key);

  ThemeController _controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 30,
            right: 20,
            child: ThemeSwitch()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _controller.isDarkMode.value
                            ? AssetImage('assets/images/walklogblack.png')
                            : AssetImage('assets/images/walklogwhite.png'),
                        fit: BoxFit
                            .fitWidth, // adjust the image to cover the whole container
                      ),
                    ));
              }),
              MyButton(
                text: "Get Started",
                onPressed: () async {
                  if (await SecurityClass.isUserNew()) {
                    Get.to(HomePage());
                  } else {
                    Get.to(UserInfoPage());
                  }
                },
                fromLeft: Colors.greenAccent,
                toRight: Colors.greenAccent.shade700,
              )
            ],
          ),
        ],
      ),
    );
  }
}
