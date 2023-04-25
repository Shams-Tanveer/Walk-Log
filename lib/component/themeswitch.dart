import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/themeController.dart';

class ThemeSwitch extends StatelessWidget {
  ThemeSwitch({super.key});

  ThemeController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        return FlutterSwitch(
          activeText: "Light",
          inactiveText: "Dark",
          activeColor: Colors.white,
          inactiveColor: Colors.black,
          activeTextColor: Colors.black,
          inactiveTextColor: Colors.white,
          inactiveToggleColor: Colors.white,
          activeToggleColor: Colors.black,
          inactiveIcon: Icon(
            Icons.nightlight_round,
            color: Colors.black,
          ),
          activeIcon: Icon(
            Icons.wb_sunny,
            color: Color.fromRGBO(253, 184, 19, 1),
          ),
          width: 75.0,
          height: 35.0,
          valueFontSize: 16.0,
          toggleSize: 25.0,
          value: _controller.isDarkMode.value,
          borderRadius: 20.0,
          showOnOff: true,
          onToggle: (val) {
            _controller.changeTheme();
          },
        );
      }),
    );
  }
}
