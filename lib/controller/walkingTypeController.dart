import 'package:get/get.dart';
import 'package:walk_log/pages/setLimitPage.dart';

class WalkignTypeController extends GetxController{
  var walkingType = "".obs;

  updateWalkingType(String type){
    walkingType.value = type;
  }
}