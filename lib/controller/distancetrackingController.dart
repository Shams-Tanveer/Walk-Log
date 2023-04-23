import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as Location;
import 'package:walk_log/controller/progressController.dart';
import 'package:walk_log/controller/setLimitController.dart';
import 'package:walk_log/functions/localDatabaseFunction.dart';
import 'package:walk_log/pages/homepage.dart';
import 'package:walk_log/pages/walkingType.dart';

import '../database/hisotryDatabase.dart';
import '../functions/firebaseFunction.dart';
import '../model/historyModel.dart';

class DistanceTrackingController extends GetxController {
  late StreamSubscription<Position> positionSubscription;

  var _lastPosition = null;
  RxDouble totalDistance = 0.0.obs;
  int target = Get.find<SetLimitController>().setLimit.value.maxValue.toInt();
  var progressController = Get.find<ProgressController>();
  @override
  void onInit() {
    super.onInit();
    _lastPosition = null;
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

    await location.requestPermission();
    await location.enableBackgroundMode(enable: true);
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
          progressController.updateProgress(target.toDouble());
          _stopTracking();
          FirebaseFunction.addCompletion(DateTime.now(),target.toDouble());
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
