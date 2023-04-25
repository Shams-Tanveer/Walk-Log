import 'dart:async';
import 'dart:io';
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

import '../notification/notificationClass.dart';
import '../pages/setLimitPage.dart';
import '../permission/permissionHandler.dart';

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
  NotificationClass _notificationClass = NotificationClass();

  @override
  Future<void> onInit() async {
    super.onInit();
    prevSteps = 0;
    steps = 0;
    _notificationClass.initializeNotification();
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
        _notificationClass.sendNotifcation("Target Completed", 'You covered ${target.toInt()} meter- WalkLog', "payLoad");
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

  void initPlatformState() async{
    await _notificationClass.requestNotificationPermissions();
    if(!await PermissionHandler.handleActivityRecognitionPermission()){
      exit(0);
    }
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
