import 'package:get/get.dart';
import 'package:walk_log/model/userModel.dart';
import 'package:walk_log/security/securityClass.dart';

class UserController extends GetxController {
  //static var user = User(uniqueId: "", height: 0.0, weight: 0.0, gender: "Gender");
  var height = 0.0.obs;
  var weight = 0.0.obs;
  var gender = "".obs;
  RxString heightType = 'cm'.obs;
  RxString weightType = 'kg'.obs;
  RxDouble heightInche = 0.0.obs;
  RxBool isFeet = false.obs;
  var errorHeight = "".obs;
  var errorWeight = "".obs;
  var errorGender = "".obs;


  _handleValidateInformation(){
    if(height.value<=0.0){
      errorHeight.value = "Enter Valid Height";
    }else{
      errorHeight.value = "";
    }
    if(weight.value<=0.0){
      errorWeight.value = "Enter Valid Weight";
    }else{
      errorWeight.value = "";
    }
    if(gender==""){
      errorGender.value = "Enter Your Gender";
    }else{
      errorGender.value = "";
    }

    if(errorGender=="" && errorHeight=="" && errorWeight==""){
      return true;
    }
    else{
      return false;
    }
  }

  addUser() {
    if(_handleValidateInformation())
    {
      SecurityClass.assignUser(_convertHeightTom(heightType.value),_convertWeightToKg(weightType.value),gender.value);
    }
  }

  double _convertHeightTom(String type) {
    if (type == 'cm') {
      return height.value / 100;
    } else if (type == 'm') {
      return height.value;
    } else if (type == 'ft') {
      return (height.value * 30.48 + heightInche.value * 2.54) / 100;
    }
    return 0.0;
  }

  double _convertWeightToKg(String type) {
    if (type == 'kg') {
      return weight.value;
    } else if (type == 'lb') {
      return weight.value * 0.453592;
    }
    return 0.0;
  }

  updateData(String field, String value) {
    if (field == "height") {
      height.value = value==""?0.0:double.parse(value);
    } else if (field == "heightInche") {
      heightInche.value = value==""?0.0:double.parse(value);
    } else if (field == "weight") {
      weight.value = value==""?0.0:double.parse(value);
    } else {
      gender.value = value;
    }
  }

  updateType(String field, String type) {
    if (field == "height") {
      if (type == "ft") {
        heightType.value = type;
        isFeet.value = true;
      } else {
        heightType.value = type;
        isFeet.value = false;
      }
    } else {}
  }
}
