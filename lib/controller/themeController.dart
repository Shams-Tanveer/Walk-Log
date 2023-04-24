import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController{
  var isDarkMode = (Get.theme.brightness == Brightness.dark).obs;
  
  void changeTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    isDarkMode.value = !isDarkMode.value;
  }
}