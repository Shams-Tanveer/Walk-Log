import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:walk_log/pages/walkingType.dart';

import '../component/customButton.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final text = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? "DarkTheme"
        : "LightTheme";
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: text == "DarkTheme"
                      ? AssetImage('assets/images/walklogblack.png')
                      : AssetImage('assets/images/walklogwhite.png'),
                  fit: BoxFit
                      .fitWidth, // adjust the image to cover the whole container
                ),
              )),
          MyButton(
            text: "Get Started",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WalkingTypePage()),
              );
            },
            fromLeft: Colors.greenAccent,
            toRight: Colors.greenAccent.shade700,
          )
        ],
      ),
    );
  }
}
