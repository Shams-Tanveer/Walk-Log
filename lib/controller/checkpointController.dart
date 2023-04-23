import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:walk_log/functions/firebaseFunction.dart';

import '../model/checkpointModel.dart';

class CheckpointController extends GetxController{
  var checkpoints = <CheckPointModel>[].obs;
  RxDouble lastCheckpoint = 0.0.obs;


  addCheckPoints(double value,DateTime timeToAdd){
    checkpoints.add(CheckPointModel(checkpointTime: timeToAdd, checkpoint: value));
    FirebaseFunction.addCheckPoints(timeToAdd, value);
  }

  updateLastCheckpoint(double value){
    lastCheckpoint.value = value;
  }

}