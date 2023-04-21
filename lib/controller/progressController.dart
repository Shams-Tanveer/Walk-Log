import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/setLimitController.dart';

class ProgressController extends GetxController{
  var progressValue = 0.0.obs;

  var _target = Get.find<SetLimitController>().setLimit.value.maxValue;
  
  updateProgress(double totalDistance){
    progressValue.value = (totalDistance / _target);
  }
}