import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:walk_log/component/themeswitch.dart';
import 'package:walk_log/controller/historyController.dart';
import 'package:walk_log/controller/themeController.dart';

import '../component/infoCard.dart';
import '../database/hisotryDatabase.dart';
import '../model/historyModel.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  final ThemeController _controller = Get.find();
  final HistoryController _historyController = Get.put(HistoryController());
  @override
  Widget build(BuildContext context) {
    final theme = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? "DarkTheme"
        : "LightTheme";
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Positioned(top: 0, right: 20, child: ThemeSwitch()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last 24 Hours",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Lato",
                          fontSize: 24),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Obx(() {
                     return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 200,
                        width: 350,
                        child: BarChart(BarChartData(
                            maxY: 1500,
                            minY: 0,
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              show: true,
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  reservedSize: 53,
                                  showTitles: true,
                                  getTitlesWidget: rightTiles,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: bottomTiles,
                                ),
                              ),
                            ),
                            barGroups: _historyController.barData
                                .map((data) =>
                                    BarChartGroupData(x: data.x, barRods: [
                                      BarChartRodData(
                                          toY: data.y,
                                          color: Colors.greenAccent.shade700,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          backDrawRodData:
                                              BackgroundBarChartRodData(
                                                  show: true,
                                                  toY: 1500,
                                                  color: _controller.isDarkMode.value?Colors.white:Colors.black))
                                    ]))
                                .toList()
                                )
                                ),
                      );
                    }),
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(() => Expanded(
                            child: InfoCard(
                              title: 'Most Active Hours',
                              subtitle: _historyController.hour24.value.toString(),
                            ),
                          )),
                          Obx(() => Expanded(
                            child: InfoCard(
                              title: 'Highest Distance Covered',
                              subtitle: _historyController.meters24.value.toString() + "m",
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(() => Expanded(
                            child: InfoCard(
                              title: 'Total Distance Covered',
                              subtitle: _historyController.distanceCovered24.toInt().toString()+ " m",
                            ),
                          ),),
                          Obx(() => Expanded(
                            child: InfoCard(
                              title: 'Total Target Completed',
                              subtitle: _historyController.totalTargetCompleted.toString(),
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Last 7days",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Lato",
                          fontSize: 24),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Obx(() => Container(
                        height: 200,
                        width: 350,
                        child: LineChart(LineChartData(
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  reservedSize: 45,
                                  showTitles: true,
                                  getTitlesWidget: rightTiles,
                                ),
                              ),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                  spots: _historyController.lineChart
                                      .map((e) => FlSpot(e.x.toDouble(), e.y))
                                      .toList(),
                                  color: Colors.greenAccent.shade700,
                                  isCurved: false,
                                  dotData: FlDotData(show: true))
                            ])),
                      )),
                    ),
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(() => Expanded(
                            child: InfoCard(
                              title: 'Most Active Day',
                              subtitle: _historyController.day7.value,
                            ),
                          )),
                          Obx(() => Expanded(
                            child: InfoCard(
                              title: 'Highest Distance Covered',
                              subtitle: _historyController.meters7.value + "m",
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget bottomTiles(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        overflow: TextOverflow.visible);

    Widget text;
    var getIn12HourFormat = _historyController.convertIn12HourFormat(value);
    int hourIn12HourFormat = getIn12HourFormat[0];
    String timeIn12HourFormat = getIn12HourFormat[1];

    if ((hourIn12HourFormat % 6) == 0) {
      text = Text(timeIn12HourFormat, style: style);
    } else {
      text = Text("", style: style);
    }

    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }

  Widget rightTiles(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

    Widget text;
    if ((value % 500) == 0) {
      text = Text(value.toInt().toString() + "m", style: style);
    } else {
      text = Text("", style: style);
    }

    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }
}
