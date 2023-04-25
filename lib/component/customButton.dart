import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/themeController.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color fromLeft;
  final Color toRight;

  MyButton(
      {required this.text,
      required this.onPressed,
      required this.fromLeft,
      required this.toRight});

  ThemeController _controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPressed(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          width: MediaQuery.of(context).size.width,
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: _controller.isDarkMode.value
                          ? Colors.white
                          : Colors.black),
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [fromLeft, toRight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Obx(() {
              return Center(
                child: Text(
                  text,
                  style: TextStyle(
                      color: _controller.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato"),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
