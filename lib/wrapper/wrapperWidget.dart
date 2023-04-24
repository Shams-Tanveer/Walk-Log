import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../component/themeswitch.dart';

class WrappingWidget extends StatelessWidget {
  final Widget child;
  WrappingWidget({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(top: 30, right: 20, child: ThemeSwitch()),
        child
      ]),
    );
  }
}
