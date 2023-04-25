import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/themeController.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final ThemeController _controller = Get.find();
    return Obx(() {
      return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: _controller.isDarkMode.value? Colors.white:Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: _controller.isDarkMode.value? Colors.black:Colors.white,
              fontSize: 14.0,
              fontFamily: "Lato",
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: "Lato",
              color: _controller.isDarkMode.value? Colors.black:Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    });
  }
}