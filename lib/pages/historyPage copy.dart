import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:walk_log/component/themeswitch.dart';
import 'package:walk_log/controller/themeController.dart';

import '../component/infoCard.dart';
import '../database/hisotryDatabase.dart';
import '../model/historyModel.dart';

class BarData {
  int x;
  double y;

  BarData({required this.x, required this.y});
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<BarData> barData = [];
  List<BarData> lineChart = [];
  String hour24 = "";
  String meters24 = "";
  double maxValue24 = 0;
  double distanceCovered24 = 0;
  String day7 = "";
  String meters7 = "";
  double maxValue7 = 0;
  double distanceCovered7 = 0;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    DateTime now = DateTime.now();

    List<History> historyList =
        await HistoryDatabase.instance.readPrevious(now);
    for (int i = 0; i < historyList.length; i++) {
      if (maxValue7 <= historyList[i].meters) {
        maxValue7 = historyList[i].meters;
        meters24 = maxValue7.toInt().toString();
        hour24 = convertIn12HourFormat(historyList[i].hour.toDouble())[1] +
            " " +
            historyList[i].date;
      }
      distanceCovered24 += historyList[i].meters;
      final value = BarData(x: historyList[i].hour, y: historyList[i].meters);
      barData.add(value);
    }
    barData = barData.reversed.toList();

    for (var i = 0; i < 7; i++) {
      var prevDate = now.subtract(Duration(days: i));
      String date = DateFormat('yyyy-MM-dd').format(prevDate);
      final total = await HistoryDatabase.instance.readOneDay(date);
      final value = BarData(x: prevDate.day, y: total);
      lineChart.add(value);
      if (total >= maxValue7) {
        maxValue7 = total;
        meters7 = total.toInt().toString();
        day7 = date;
      }
    }

    lineChart = lineChart.reversed.toList();
    setState(() {});
  }

  final ThemeController _controller = Get.find();

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
                    Container(
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
                            barGroups: barData
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
                                                  color: Colors.grey))
                                    ]))
                                .toList()
                                )
                                ),
                      ),
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InfoCard(
                              title: 'Most Active Hours',
                              subtitle: hour24.toString(),
                            ),
                          ),
                          Expanded(
                            child: InfoCard(
                              title: 'Highest Distance Covered',
                              subtitle: meters24.toString() + "m",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InfoCard(
                              title: 'Total Distance Covered',
                              subtitle: distanceCovered24.toInt().toString(),
                            ),
                          ),
                          Expanded(
                            child: InfoCard(
                              title: 'Highest Distance Covered',
                              subtitle: meters24.toString() + "m",
                            ),
                          ),
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
                      child: Container(
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
                                  spots: lineChart
                                      .map((e) => FlSpot(e.x.toDouble(), e.y))
                                      .toList(),
                                  color: Colors.greenAccent.shade700,
                                  isCurved: false,
                                  dotData: FlDotData(show: true))
                            ])),
                      ),
                    ),
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InfoCard(
                              title: 'Most Active Day',
                              subtitle: day7,
                            ),
                          ),
                          Expanded(
                            child: InfoCard(
                              title: 'Highest Distance Covered',
                              subtitle: meters7 + "m",
                            ),
                          ),
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

  List convertIn12HourFormat(double value) {
    int value1 = value.toInt();
    int hourIn12HourFormat = value1 > 12
        ? value1 - 12
        : value1 != 0
            ? value1
            : 12;
    String amOrPm = value1 >= 12 ? 'pm' : 'am';
    String timeIn12HourFormat = '$hourIn12HourFormat ${amOrPm}';
    return [hourIn12HourFormat, timeIn12HourFormat];
  }

  Widget bottomTiles(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        overflow: TextOverflow.visible);

    Widget text;
    var getIn12HourFormat = convertIn12HourFormat(value);
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
