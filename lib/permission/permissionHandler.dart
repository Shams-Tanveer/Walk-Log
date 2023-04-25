import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as pHandler;
import 'package:walk_log/component/snackBar.dart';

class PermissionHandler {
  static Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    Location location = Location();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      SnackBarUtility.showSnackBar(
          'Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SnackBarUtility.showSnackBar('Location permissions are denied');
        return false;
      } else {
        if (!await location.isBackgroundModeEnabled()) {
          await PermissionHandler.handleBackgroundLocationPermission(context);
        }
      }
    }
    if (permission == LocationPermission.deniedForever) {
      SnackBarUtility.showSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  static Future<void> handleBackgroundLocationPermission(
      BuildContext context) async {
    Location location = Location();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.greenAccent.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(
              'Background mode required',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: const Text(
              'Location tracking requires background mode. Do you want to continue?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                  await location.enableBackgroundMode(enable: true);
                },
                child: Text(
                  'Open Setting',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
              ),
            ],
          );
        });
  }

  static Future<bool> handleActivityRecognitionPermission() async {
    var status = await pHandler.Permission.activityRecognition.status;
    print(status);
    if (status == pHandler.PermissionStatus.denied) {
      print("Called");
      status = await pHandler.Permission.activityRecognition.request();
      if (status == pHandler.PermissionStatus.denied) {
        print("Called2");
        SnackBarUtility.showSnackBar(
            'Activity Recognition permissions are denied');
        return false;
      }
    }

    if (status == pHandler.PermissionStatus.permanentlyDenied) {
      SnackBarUtility.showSnackBar(
          'Activity Recognition permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    print(status);
    print("Called1");
    return true;
  }
}
