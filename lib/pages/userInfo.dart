import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/userController.dart';

import '../component/customButton.dart';

class FitnessWidget extends StatefulWidget {
  const FitnessWidget({super.key});

  @override
  _FitnessWidgetState createState() => _FitnessWidgetState();
}

class _FitnessWidgetState extends State<FitnessWidget> {
  TextEditingController _genderController = TextEditingController();
  final UserController _userController = Get.put(UserController());

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<UserController>();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final text = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? "DarkTheme"
        : "LightTheme";
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
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
                                  width: 2, color: Colors.greenAccent.shade700),
                            ),
                            labelText: 'Gender',
                            labelStyle: TextStyle(
                                fontFamily: "Lato",
                                color: text == "DarkTheme"
                                    ? Colors.white
                                    : Colors.black)),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 105,
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.greenAccent.shade700,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.greenAccent.shade700),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: text == "DarkTheme"
                                        ? Colors.white
                                        : Colors.black))),
                        style: TextStyle(
                            fontFamily: "Lato",
                            color: text == "DarkTheme"
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16),
                        value: _userController.gender.value,
                        onChanged: (String? value) {
                          _genderController.text = value!;
                          _userController.updateData("gender", value);
                        },
                        items: <String>[
                          "",
                          'Male',
                          'Female',
                          'Other',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
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
              SizedBox(height: 20),
              Obx(() {
                return _userController.isFeet.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.greenAccent.shade700,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.greenAccent.shade700),
                                  ),
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorText:
                                      _userController.errorHeight.value == ""
                                          ? null
                                          : _userController.errorHeight.value,
                                  labelText: 'Feet',
                                  labelStyle: TextStyle(
                                      fontFamily: "Lato",
                                      color: text == "DarkTheme"
                                          ? Colors.white
                                          : Colors.black)),
                              onChanged: (value) {
                                _userController.updateData("height", value);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.greenAccent.shade700,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.greenAccent.shade700),
                                  ),
                                  labelText: 'Inches',
                                  labelStyle: TextStyle(
                                      fontFamily: "Lato",
                                      color: text == "DarkTheme"
                                          ? Colors.white
                                          : Colors.black)),
                              onChanged: (value) {
                                _userController.updateData(
                                    "heightInche", value);
                              },
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            width: 105,
                            child: DropdownButtonFormField<String>(
                              dropdownColor: Colors.greenAccent.shade700,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.greenAccent.shade700),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: text == "DarkTheme"
                                              ? Colors.white
                                              : Colors.black))),
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  color: text == "DarkTheme"
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16),
                              value: _userController.heightType.value,
                              onChanged: (String? value) {
                                _userController.updateType("height", value!);
                              },
                              items: <String>[
                                'cm',
                                'm',
                                'ft',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.greenAccent.shade700,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.greenAccent.shade700),
                                  ),
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorText:
                                      _userController.errorHeight.value == ""
                                          ? null
                                          : _userController.errorHeight.value,
                                  labelText: 'Height',
                                  labelStyle: TextStyle(
                                      fontFamily: "Lato",
                                      color: text == "DarkTheme"
                                          ? Colors.white
                                          : Colors.black)),
                              onChanged: (value) {
                                _userController.updateData("height", value);
                              },
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                              width: 105,
                              child: DropdownButtonFormField<String>(
                                dropdownColor: Colors.greenAccent.shade700,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.greenAccent.shade700),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: text == "DarkTheme"
                                                ? Colors.white
                                                : Colors.black))),
                                style: TextStyle(
                                    color: text == "DarkTheme"
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "Lato",
                                    fontSize: 16),
                                value: _userController.heightType.value,
                                onChanged: (String? value) {
                                  _userController.updateType("height", value!);
                                },
                                items: <String>[
                                  'cm',
                                  'm',
                                  'ft',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ))
                        ],
                      );
              }),
              SizedBox(height: 20),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.greenAccent.shade700,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.greenAccent.shade700),
                            ),
                            errorText: _userController.errorWeight.value == ""
                                ? null
                                : _userController.errorWeight.value,
                            errorStyle: TextStyle(color: Colors.red),
                            labelText: 'Weight',
                            labelStyle: TextStyle(
                                fontFamily: "Lato",
                                color: text == "DarkTheme"
                                    ? Colors.white
                                    : Colors.black)),
                        onChanged: (value) {
                          _userController.updateData("weight", value);
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 105,
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.greenAccent.shade700,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.greenAccent.shade700),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: text == "DarkTheme"
                                        ? Colors.white
                                        : Colors.black))),
                        style: TextStyle(
                            color: text == "DarkTheme"
                                ? Colors.white
                                : Colors.black,
                            fontFamily: "Lato",
                            fontSize: 16),
                        value: _userController.weightType.value,
                        onChanged: (String? value) {
                          _userController.updateType("weight", value!);
                        },
                        items: <String>[
                          'kg',
                          'lb',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                );
              }),
              SizedBox(height: 20),
              MyButton(
                text: "Save",
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      });
                  _userController.addUser();
                },
                fromLeft: Colors.greenAccent,
                toRight: Colors.greenAccent.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
