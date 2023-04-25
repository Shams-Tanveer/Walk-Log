import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController{
  var isDarkMode = (SchedulerBinding.instance.window.platformBrightness == Brightness.dark).obs;
  
  void changeTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.light : ThemeMode.dark);
    isDarkMode.value = !isDarkMode.value;
  }
}