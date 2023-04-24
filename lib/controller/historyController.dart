import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:walk_log/functions/firebaseFunction.dart';

import '../database/hisotryDatabase.dart';
import '../model/bardataModel.dart';
import '../model/historyModel.dart';

class HistoryController extends GetxController{
  var barData = [].obs;
  var lineChart = [].obs;
  var hour24 = "".obs;
  var meters24 = "".obs;
  var maxValue24 = 0.0.obs;
  var distanceCovered24 = 0.0.obs;
  var day7 = "".obs;
  var meters7 = "".obs;
  var maxValue7 = 0.0.obs;
  var distanceCovered7 = 0.0.obs;
  var totalTargetCompleted = 0.obs;

  
  @override
  void onInit() {
    super.onInit();
    loadData();
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

  void loadData() async {
    DateTime now = DateTime.now();

    List<History> historyList =
        await HistoryDatabase.instance.readPrevious(now);
    for (int i = 0; i < historyList.length; i++) {
      if (maxValue24.value <= historyList[i].meters) {
        maxValue24.value = historyList[i].meters;
        meters24.value = maxValue24.toInt().toString();
        hour24.value = convertIn12HourFormat(historyList[i].hour.toDouble())[1] +
            " " +
            historyList[i].date;
      }
      distanceCovered24.value += historyList[i].meters;
      final value = BarData(x: historyList[i].hour, y: historyList[i].meters);
      barData.add(value);
    }
    barData.value = barData.reversed.toList();

    for (var i = 0; i < 7; i++) {
      var prevDate = now.subtract(Duration(days: i));
      String date = DateFormat('yyyy-MM-dd').format(prevDate);
      final total = await HistoryDatabase.instance.readOneDay(date);
      final value = BarData(x: prevDate.day, y: total);
      lineChart.add(value);
      if (total >= maxValue7.value) {
        maxValue7.value = total;
        meters7.value = total.toInt().toString();
        day7.value = date;
      }
    }
    lineChart.value = lineChart.reversed.toList();
    totalTargetCompleted.value = await FirebaseFunction.totalCompletedTarget();
  }
}