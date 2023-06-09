import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walk_log/controller/themeController.dart';
import 'package:walk_log/pages/historyPage.dart';
import '../component/appName.dart';
import '../component/customButton.dart';
import '../component/customSliderThumb.dart';
import '../component/themeswitch.dart';
import '../controller/setLimitController.dart';
import 'distanceTrackingPage.dart';

class SetLimiPage extends StatelessWidget {
  SetLimiPage({Key? key}) : super(key: key);

  Color color = Colors.greenAccent.shade400;
  final maxValueController = TextEditingController();
  final SetLimitController setLimitController = Get.put(SetLimitController());
  final ThemeController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Positioned(
                                  top: 30, right: 20, child: ThemeSwitch()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 150,
                                      width: 150,
                                      child: AppName()),
                                  Text(
                                    "Set your target now",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontFamily: "Lato",
                                        fontSize: 39),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Set your walking limit today and unlock your body and mind's potential for a healthier, happier you. Challenge yourself and take the first step towards a better lifestyle.",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: "Lato", fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))),
                SizedBox(
                  height: 40,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                controller: maxValueController,
                                keyboardType: TextInputType.number,
                                cursorColor: color,
                                decoration: InputDecoration(
                                    labelText: "Set Limit",
                                    errorText: setLimitController
                                            .setLimit.value.errorInSetLimit
                                        ? setLimitController
                                            .setLimit.value.errorInSetLimitText
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 3, color: color),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 3, color: color),
                                    ),
                                    labelStyle: _controller.isDarkMode.value
                                        ? const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)
                                        : const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                onChanged: (value) {
                                  setLimitController.updateValue(value);
                                },
                              ),
                            );
                          }),
                          SizedBox(
                            height: 5,
                          ),
                          Obx(() {
                            return Container(
                              width: 350,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbColor: Colors.black,
                                  thumbShape: RectangularSliderThumb(),
                                ),
                                child: Slider(
                                  value: setLimitController
                                      .setLimit.value.maxValue,
                                  min: 0,
                                  max: 10000,
                                  divisions: 100,
                                  inactiveColor: _controller.isDarkMode.value
                                      ? Colors.white
                                      : Colors.black,
                                  activeColor: Colors.greenAccent.shade700,
                                  onChanged: (value) {
                                    setLimitController
                                        .updateValue(value.toString());
                                    maxValueController.text =
                                        value.toStringAsFixed(0);
                                  },
                                  label: setLimitController
                                      .setLimit.value.maxValue
                                      .toInt()
                                      .toString(),
                                ),
                              ),
                            );
                          }),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("0 m"), Text("10000 m")],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(() {
                            return MyButton(
                              text: "Start Walking",
                              onPressed: setLimitController
                                      .setLimit.value.errorInSetLimit
                                  ? () {}
                                  : () {
                                      Get.to(DistanceTracking());
                                    },
                              fromLeft: setLimitController
                                      .setLimit.value.errorInSetLimit
                                  ? Colors.grey.shade400
                                  : Colors.greenAccent,
                              toRight: setLimitController
                                      .setLimit.value.errorInSetLimit
                                  ? Colors.grey.shade400
                                  : Colors.greenAccent.shade700,
                            );
                          }),
                          MyButton(
                              text: "History",
                              onPressed: () {
                                Get.to(HistoryPage());
                              },
                              fromLeft: _controller.isDarkMode.value
                                  ? Colors.black
                                  : Colors.white,
                              toRight: _controller.isDarkMode.value
                                  ? Colors.black
                                  : Colors.white),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
