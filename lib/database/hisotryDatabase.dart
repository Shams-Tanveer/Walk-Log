import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/historyModel.dart';

class HistoryDatabase{
  static final HistoryDatabase instance = HistoryDatabase._init();
  static Database? _database;
  HistoryDatabase._init();


  Future<Database> get database async{
    if(_database!= null) return _database!;
    _database = await _initDB('history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }


  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = "TEXT NOT NULL";
    final intType = 'INTEGER NOT NULL';
    final realType = 'REAL NOT NULL';

    await db.execute('''
    CREATE TABLE $tableName(
      ${HistoryField.id} $idType,
      ${HistoryField.date} $textType,
      ${HistoryField.hour} $intType,
      ${HistoryField.meters} $textType
    )
    ''');
  }

  Future<History> create(History history) async {
    final db = await instance.database;
    final id = await db.insert(tableName, history.toJson());
    return history.copy(id: id);
  }

  Future<History?> readOne(String date,int hour) async{
    final db = await instance.database;
    final result = await db.query(tableName,where: 'date=? AND hour=?',whereArgs: [date,hour]);
    if(result.isNotEmpty){
      return History.fromJson(result.first);
    }else{
      return null;
    }
  }


  Future<double> readOneDay(String date)async{
    double distance = 0;
    final db = await instance.database;
    final result = await db.query(tableName,where: 'date=?',whereArgs: [date]);
    var oneDayList = result.map((json) => History.fromJson(json)).toList();
    
    if(oneDayList.isEmpty)
    {
      return distance;
    }else{
      for(var i=0;i<oneDayList.length;i++){
        distance += oneDayList[i].meters;
      }
      return distance;
    }
  }

  Future<List<History>> readAll()async{
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json) => History.fromJson(json)).toList();
  }


  Future<List<History>> readPrevious(DateTime currentDate) async{
    final db = await instance.database;
    final prevHours = 24;
    List<History> previousHistory = [];
    for(int i=0;i<prevHours;i++){
      DateTime prevTime = currentDate.subtract(Duration(hours: i));
      int hour = prevTime.hour;
      String date = DateFormat('yyyy-MM-dd').format(prevTime);
      final result = await readOne(date, hour);
      if(result == null){
        final history = History(date: date, hour: hour, meters: 0.0);
        previousHistory.add(history);
      }else{
        previousHistory.add(result);
      }
    }
    return previousHistory;
  }

  Future<int> update(History history)async{
    final db = await instance.database;

    return db.update(
      tableName, 
      history.toJson(),
      where: '${HistoryField.id}=?',
      whereArgs: [history.id]
      );
  }

  Future<int> delete(int id) async{
    final db = await instance.database;
    return await db.delete(
      tableName,
      where: '${HistoryField.id} = ?',
      whereArgs: [id]
    );
  }
  Future deleteAll() async{
      final db = await instance.database;
      await db.delete(tableName);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}