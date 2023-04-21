import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? "DarkTheme"
        : "LightTheme";
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPressed(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal:24,vertical: 10),
          width: MediaQuery.of(context).size.width,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [fromLeft, toRight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: theme=="LightTheme"? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lato"
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
