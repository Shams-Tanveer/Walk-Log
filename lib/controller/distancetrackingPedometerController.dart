import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:walk_log/controller/progressController.dart';
import 'package:walk_log/controller/setLimitController.dart';
import 'package:walk_log/functions/firebaseFunction.dart';
import 'package:walk_log/functions/localDatabaseFunction.dart';
import 'package:walk_log/pages/walkfinishingPage.dart';
import 'package:walk_log/security/securityClass.dart';

import '../pages/homepage.dart';

class DistanceTrackingPedometerController extends GetxController {
  late StreamSubscription<PedestrianStatus> _pedestrianStatusStream;
  late StreamSubscription<StepCount> _stepCountStream;
  late int prevSteps;
  late int steps;
  late int moreSteps;
  late double strideLength;
  String status = 'LOADING';
  RxDouble totalDistance = 0.0.obs;
  int target = Get.find<SetLimitController>().setLimit.value.maxValue.toInt();
  var progressController = Get.find<ProgressController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    prevSteps = 0;
    steps = 0;
    strideLength = await SecurityClass.getStrideLength();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    _stopTracking();
  }

  void onStepCount(StepCount event) {
    if (prevSteps == 0) {
      prevSteps = event.steps;
      steps = 0;
    } else if (event.steps - prevSteps >= 13) {
      moreSteps = event.steps - prevSteps;
      steps += moreSteps;
      prevSteps = event.steps;
      double distance = (moreSteps * strideLength);
      totalDistance.value += distance;
      LocalDatabaseFunction.addToDatabase(distance);
      if (totalDistance >= target) {
        progressController.updateProgress(target.toDouble());
        _stopTracking();
        FirebaseFunction.addCompletion(DateTime.now(),target.toDouble());
      } else {
        progressController.updateProgress(totalDistance.value);
      }
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    status = event.status;
  }

  void onPedestrianStatusError(error) {
    status = 'Pedestrian Status not available';
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    steps = -1;
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream.listen((event) {
      onPedestrianStatusChanged(event);
    }, onError: (error) {
      onPedestrianStatusError(error);
    });
    _stepCountStream = Pedometer.stepCountStream.listen((event) {
      onStepCount(event);
    }, onError: (error) {
      onPedestrianStatusError(error);
    });
  }

  _stopTracking() {
    _pedestrianStatusStream.cancel();
    _stepCountStream.cancel();
  }
}
