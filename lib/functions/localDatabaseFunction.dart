import 'package:intl/intl.dart';

import '../database/hisotryDatabase.dart';
import '../model/historyModel.dart';

class LocalDatabaseFunction{
    static void addToDatabase(double distance)async{
    DateTime now = DateTime.now();
    int hour = now.hour;
    String date = DateFormat('yyyy-MM-dd').format(now);
    History? record = await HistoryDatabase.instance.readOne(date, hour);
    if(record == null){
      final history = History(date: date, hour: hour, meters: distance);
      await HistoryDatabase.instance.create(history);
    }else{
      final history = record.copy(
        meters: record.meters+distance
      );
      await HistoryDatabase.instance.update(history);
  }
  }
}