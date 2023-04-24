import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/themeController.dart';
import 'package:walk_log/controller/userController.dart';

import '../component/customButton.dart';
import '../component/themeswitch.dart';

class UserInfoPage extends StatelessWidget {

  TextEditingController _genderController = TextEditingController();
  final UserController _userController = Get.put(UserController());
  final ThemeController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(top: 30, right: 20, child: ThemeSwitch()),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter your information',
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              controller: _genderController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.greenAccent.shade700),
                                  ),
                                  labelText: 'Gender',
                                  labelStyle: TextStyle(
                                      fontFamily: "Lato",
                                      color: _controller.isDarkMode.value
                                          ? Colors.black
                                          : Colors.white)),
                            ),
                          ),
                          SizedBox(width: 20),
                          customDropDown([
                            "",
                            'Male',
                            'Female',
                            'Other',
                          ], _userController.gender.value, "gender"),
                        ],
                      );
                    }),
                    Obx(
                      () => Container(
                        padding: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _userController.errorGender.value == ""
                              ? ""
                              : _userController.errorGender.value,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Obx(() {
                      return _userController.isFeet.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextFormField(
                                    "Feet",
                                    _userController.errorHeight.value,
                                    "height"),
                                SizedBox(
                                  width: 8,
                                ),
                                CustomTextFormField(
                                    "Inches", "", "heightInche"),
                                SizedBox(width: 20),
                                customDropDown([
                                  'cm',
                                  'm',
                                  'ft',
                                ], _userController.heightType.value, "height"),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextFormField(
                                    "Height",
                                    _userController.errorHeight.value,
                                    "height"),
                                SizedBox(width: 20),
                                customDropDown([
                                  'cm',
                                  'm',
                                  'ft',
                                ], _userController.heightType.value, "height"),
                              ],
                            );
                    }),
                    SizedBox(height: 20),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextFormField("Weight",
                              _userController.errorWeight.value, "weight"),
                          SizedBox(width: 20),
                          customDropDown([
                            'kg',
                            'lb',
                          ], _userController.weightType.value, "weight"),
                        ],
                      );
                    }),
                    SizedBox(height: 20),
                    MyButton(
                      text: "Save",
                      onPressed: () {
                        _userController.addUser(context);
                      },
                      fromLeft: Colors.greenAccent,
                      toRight: Colors.greenAccent.shade700,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomTextFormField(
      String fieldName, String error, String identifyFunction) {
    return Expanded(
      child: TextFormField(
        keyboardType: TextInputType.number,
        cursorColor: Colors.greenAccent.shade700,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(width: 2, color: Colors.greenAccent.shade700),
            ),
            errorText: error == "" ? null : error,
            errorStyle: TextStyle(color: Colors.red),
            labelText: fieldName,
            labelStyle: TextStyle(
                fontFamily: "Lato",
                color: _controller.isDarkMode.value
                    ? Colors.black
                    : Colors.white)),
        onChanged: (value) {
          _userController.updateData(identifyFunction, value);
        },
      ),
    );
  }

  Widget customDropDown(
      List<String> items, String value, String identifyFunction) {
    return Container(
      width: 105,
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.greenAccent.shade700,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(width: 2, color: Colors.greenAccent.shade700),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: _controller.isDarkMode.value
                        ? Colors.black
                        : Colors.white))),
        style: TextStyle(
            fontFamily: "Lato",
            color: _controller.isDarkMode.value ? Colors.black : Colors.white,
            fontSize: 16),
        value: value,
        onChanged: (String? value) {
          if (identifyFunction == "gender") {
            _genderController.text = value!;
          }
          _userController.updateType(identifyFunction, value!);
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
