import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String hour = "";
  String meters = "";
  double maxValue = 0;
  double distanceCovered = 0;
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
      if (maxValue <= historyList[i].meters) {
        maxValue = historyList[i].meters;
        meters = maxValue.toInt().toString();
        hour = convertIn12HourFormat(historyList[i].hour.toDouble())[1] +
            " " +
            historyList[i].date;
      }
      distanceCovered += historyList[i].meters;
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
    }

    lineChart = lineChart.reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? "DarkTheme"
        : "LightTheme";
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
              height: 20,
            ),
            Container(
              height: 250,
              width: 350,
              child: BarChart(BarChartData(
                  maxY: 1500,
                  minY: 0,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                      .map((data) => BarChartGroupData(x: data.x, barRods: [
                            BarChartRodData(
                                toY: data.y,
                                color: Colors.greenAccent.shade700,
                                borderRadius: BorderRadius.circular(2),
                                backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: 1500,
                                    color: theme == "DarkTheme"
                                        ? Colors.white
                                        : Colors.black))
                          ]))
                      .toList())),
            ),
            //SizedBox(height: 10,),
            //Text("Your Most Active Hours "+hour),
            //SizedBox(height: 10,),
            //Text("Most Active Hours You Covered: "+meters+"m"),
            //SizedBox(height: 10,),
            //Text("In Last 24 hours You Covered "+distanceCovered.toInt().toString()+"m"),
            //SizedBox(height: 10,),
            Container(
              height: 250,
              width: 350,
              child: LineChart(LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    
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
            )
          ],
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
