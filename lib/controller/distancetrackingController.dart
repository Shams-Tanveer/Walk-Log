import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as Location;
import 'package:walk_log/controller/progressController.dart';
import 'package:walk_log/controller/setLimitController.dart';
import 'package:walk_log/functions/localDatabaseFunction.dart';
import 'package:walk_log/pages/setLimitPage.dart';
import 'package:walk_log/pages/homePage.dart';
import 'package:walk_log/permission/permissionHandler.dart';

import '../database/hisotryDatabase.dart';
import '../functions/firebaseFunction.dart';
import '../model/historyModel.dart';
import '../notification/notificationClass.dart';

class DistanceTrackingController extends GetxController {
  BuildContext context;
  DistanceTrackingController({required this.context});

  late StreamSubscription<Position> positionSubscription;
  var _lastPosition = null;
  RxDouble totalDistance = 0.0.obs;
  int target = Get.find<SetLimitController>().setLimit.value.maxValue.toInt();
  var progressController = Get.find<ProgressController>();
  NotificationClass _notificationClass = NotificationClass();
  @override
  void onInit() {
    super.onInit();
    _lastPosition = null;
    _notificationClass.initializeNotification();
    _startTracking();
  }

  @override
  void dispose() {
    super.dispose();
    _stopTracking();
  }

  void _startTracking() async {
    Location.Location location = Location.Location();
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    await _notificationClass.requestNotificationPermissions();
    await PermissionHandler.handleLocationPermission(context);
    positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((position) {
      if (_lastPosition != null) {
        double distance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        totalDistance.value += distance;
        LocalDatabaseFunction.addToDatabase(distance);

        if (totalDistance >= target) {
          _notificationClass.sendNotifcation("Target Completed", 'You covered ${target.toInt()} meter- WalkLog', "payLoad");
          progressController.updateProgress(target.toDouble());
          _stopTracking();
          FirebaseFunction.addCompletion(DateTime.now(), target.toDouble());
        } else {
          progressController.updateProgress(totalDistance.value);
        }
      }
      _lastPosition = position;
    });
  }

  void _stopTracking() {
    positionSubscription.cancel();
  }
}
