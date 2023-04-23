import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/distancetrackingPedometerController.dart';

import 'controller/checkpointController.dart';
import 'controller/progressController.dart';
import 'controller/setLimitController.dart';

class PedometerImplementation extends StatelessWidget {
  PedometerImplementation({super.key});
  final SetLimitController _setLimitController = Get.put(SetLimitController());
  final CheckpointController _checkpointController =
      Get.put(CheckpointController());

  final ProgressController _progressController = Get.put(ProgressController());
  final DistanceTrackingPedometerController _distanceTrackingPedometerController = Get.put(DistanceTrackingPedometerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Obx(() {
        return Text(
        _distanceTrackingPedometerController.totalDistance.toString(),
        textDirection: TextDirection.ltr,
        style: const TextStyle(
            fontSize: 60.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'GoogleBold',
            color: Colors.white),
      );
      })
    ),
    );
  }
}