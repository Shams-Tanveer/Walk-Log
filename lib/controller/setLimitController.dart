import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/setLimitModel.dart';

class SetLimitController extends GetxController {
  var setLimit = SetLimitModel(
          maxValue: 10000,
          errorInSetLimit: false,
          errorInSetLimitText: "")
      .obs;

  updateValue(String changedValue) {
    late double value;
    if(changedValue==""){
      value = 0.0;
    }else{
      value= double.parse(changedValue);
    }
    if (value > 10000) {
      setLimit.value = SetLimitModel(
        maxValue: 10000, 
        errorInSetLimit: true, 
        errorInSetLimitText: "Your Cannot Set Limit Higher than 10000m");
    } else if (value < 1) {
      setLimit.value = SetLimitModel(
        maxValue: 1, 
        errorInSetLimit: true, 
        errorInSetLimitText: "Your Cannot Set Limit Less Than 1m");
    } else {
      setLimit.value = SetLimitModel(
        maxValue: value, 
        errorInSetLimit: false, 
        errorInSetLimitText: "");
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
