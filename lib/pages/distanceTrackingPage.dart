import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:walk_log/component/snackBar.dart';
import 'package:walk_log/controller/distancetrackingPedometerController.dart';
import 'package:walk_log/controller/themeController.dart';
import 'package:walk_log/controller/walkingTypeController.dart';

import '../component/customButton.dart';
import '../component/themeswitch.dart';
import '../controller/checkpointController.dart';
import '../controller/distancetrackingController.dart';
import '../controller/progressController.dart';
import '../controller/setLimitController.dart';
import '../permission/permissionHandler.dart';

class DistanceTracking extends StatefulWidget {
  const DistanceTracking({Key? key}) : super(key: key);

  @override
  State<DistanceTracking> createState() => _DistanceTrackingState();
}

class _DistanceTrackingState extends State<DistanceTracking>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late final _distanceTrackingController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    if (_walkignTypeController.walkingType.value == "outdoor") {
      _distanceTrackingController = Get.put(DistanceTrackingController(context: context));
    } else {
      _distanceTrackingController =
          Get.put(DistanceTrackingPedometerController());
    }
  }

  @override
  void dispose() {
    if (_walkignTypeController.walkingType.value == "outdoor") {
      Get.delete<DistanceTrackingController>();
    } else {
      Get.delete<DistanceTrackingPedometerController>();
    }
    Get.delete<SetLimitController>();
    Get.delete<CheckpointController>();
    Get.delete<WalkignTypeController>();
    Get.delete<ProgressController>();
    _animationController.dispose();
    super.dispose();
  }

  final SetLimitController _setLimitController = Get.find();
  final CheckpointController _checkpointController =
      Get.put(CheckpointController());
  final WalkignTypeController _walkignTypeController =
      Get.put(WalkignTypeController());
  final ProgressController _progressController = Get.put(ProgressController());
  final ThemeController _controller = Get.find();

  Future<bool> _onWillPop() async {
    SnackBarUtility.showSnackBar("You Cannot Get Back to Previous Screen.");
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade700,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(top: 30, right: 20, child: ThemeSwitch()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(() {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: LiquidCustomProgressIndicator(
                                    value: _progressController
                                        .progressValue.value, // Defaults to 0.5.
                                    valueColor: AlwaysStoppedAnimation(Color(
                                        0xff880808)), // Defaults to the current Theme's accentColor.
                                    backgroundColor: Colors.white,
                                    direction: Axis.vertical,
                                    shapePath: _buildHeartPath(150, 100),
                                    center: Text(
                                      '${(_progressController.progressValue.value * 100).toInt().toString()}%',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Obx(() {
                                        return Text(
                                          'Covered Distance:',
                                          style: TextStyle(
                                              color: _controller.isDarkMode.value
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontFamily: 'Lato',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }),
                                      Obx(() {
                                        return Text(
                                          _distanceTrackingController
                                              .totalDistance.value
                                              .toInt()
                                              .toString(),
                                          style: TextStyle(
                                              color: _controller.isDarkMode.value
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontFamily: 'Lato',
                                              fontSize: 28),
                                        );
                                      })
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Obx(() {
                                        return Text(
                                          'Total Distance:',
                                          style: TextStyle(
                                              color: _controller.isDarkMode.value
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontFamily: 'Lato',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }),
                                      Obx(() {
                                        return Text(
                                          '${_setLimitController.setLimit.value.maxValue.toInt().toString()} m',
                                          style: TextStyle(
                                              color: _controller.isDarkMode.value
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontFamily: 'Lato',
                                              fontSize: 28),
                                        );
                                      })
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                Obx(() {
                  return Expanded(
                    flex: 2,
                    child: ListView.builder(
                        itemCount: _checkpointController.checkpoints.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            child: Center(
                                child: ListTile(
                              leading: Icon(Icons.flag),
                              title: Text("Checkpoint " + index.toString()),
                              trailing: Text(
                                  '${_checkpointController.checkpoints[index].checkpoint.round().toString()} m'),
                            )),
                          );
                        }),
                  );
                }),
                MyButton(
                  text: "Add CheckPoints",
                  onPressed: () {
                    _checkpointController.addCheckPoints(
                        _distanceTrackingController.totalDistance.value -
                            _checkpointController.lastCheckpoint.value,
                        DateTime.now());
                    _checkpointController.updateLastCheckpoint(
                        _distanceTrackingController.totalDistance.value);
                  },
                  fromLeft: Colors.greenAccent,
                  toRight: Colors.greenAccent.shade700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Path _buildHeartPath(double width, double height) {
    return Path()
      ..moveTo(60.5 * width / 116, 22 * height / 79.75)
      ..cubicTo(60.5 * width / 116, 8.25 * height / 79.75, 52.25 * width / 116,
          0, 38.5 * width / 116, 0)
      ..cubicTo(19.25 * width / 116, 0, 5 * width / 116, 16.5 * height / 79.75,
          5 * width / 116, 35.75 * height / 79.75)
      ..cubicTo(5 * width / 116, 50 * height / 79.75, 16.5 * width / 116,
          66 * height / 79.75, 30.25 * width / 116, 79.75 * height / 79.75)
      ..lineTo(60.5 * width / 116, 110 * height / 79.75)
      ..lineTo(90.75 * width / 116, 79.75 * height / 79.75)
      ..cubicTo(104.5 * width / 116, 66 * height / 79.75, 116 * width / 116,
          50 * height / 79.75, 116 * width / 116, 35.75 * height / 79.75)
      ..cubicTo(116 * width / 116, 16.5 * height / 79.75, 102.75 * width / 116,
          0, 83.5 * width / 116, 0)
      ..cubicTo(70.25 * width / 116, 0, 60.5 * width / 116,
          8.25 * height / 79.75, 60.5 * width / 116, 22 * height / 79.75)
      ..close();
  }
}
