import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: const [
          Text(
            'Walk',
            style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Amsterdam",fontSize: 39),
          ),
          Padding(
            padding: EdgeInsets.only(top: 55),
            child: Text(
              'Log',
              style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Comic",fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }
}