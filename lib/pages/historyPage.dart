import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
      final value = BarData(x: historyList[i].hour, y: historyList[i].meters);
      barData.add(value);
    }
    barData = barData.reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 450,
        width: 350,
        child: BarChart(BarChartData(
            maxY: 1500,
            minY: 0,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2),
                          backDrawRodData: BackgroundBarChartRodData(
                              show: true, toY: 1500, color: Colors.grey))
                    ]))
                .toList())),
      ),
    );
  }

  Widget bottomTiles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
        overflow: TextOverflow.visible);

    Widget text;
    int value1 = value.toInt();
    int hourIn12HourFormat = value1 > 12
        ? value1 - 12
        : value1 != 0
            ? value1
            : 12;
    String amOrPm = value1 >= 12 ? 'pm' : 'am';
    String timeIn12HourFormat = '$hourIn12HourFormat ${amOrPm}';

    if ((hourIn12HourFormat % 6) == 0) {
      text = Text(timeIn12HourFormat, style: style);
    } else {
      text = Text("", style: style);
    }

    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }

  Widget rightTiles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);

    Widget text;
    if ((value % 500) == 0) {
      text = Text(value.toInt().toString() + "m", style: style);
    } else {
      text = Text("", style: style);
    }

    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }
}
