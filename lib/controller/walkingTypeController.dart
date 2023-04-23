import 'package:get/get.dart';
import 'package:walk_log/pages/homepage.dart';

class WalkignTypeController extends GetxController{
  var walkingType = "".obs;

  updateWalkingType(String type){
    walkingType.value = type;
  }
}