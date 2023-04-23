import 'package:cloud_firestore/cloud_firestore.dart';

final String tableName ="checkpoints";

class CheckPointField{
  static const String userId = "userId";
  static const String checkpoint = "checkpoint";
  static const String checkpointTime = "checkpointTime";
}

class CheckPointModel{
  String? userId;
  double checkpoint;
  DateTime checkpointTime;

  CheckPointModel({
    this.userId,
    required this.checkpointTime,
    required this.checkpoint
  });


  Map<String, dynamic> toJson()=>{
    CheckPointField.userId: userId,
    CheckPointField.checkpoint: checkpoint,
    CheckPointField.checkpointTime: checkpointTime
  };

  static CheckPointModel fromJson(Map<String, Object?> json) =>CheckPointModel(
    userId: json[CheckPointField.userId] as String, 
    checkpoint: json[CheckPointField.checkpoint] as double, 
    checkpointTime: (json[CheckPointField.checkpointTime] as Timestamp) as DateTime);
}