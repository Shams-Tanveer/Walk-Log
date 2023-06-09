import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:walk_log/component/snackBar.dart';
import 'package:walk_log/model/checkpointModel.dart';
import 'package:walk_log/pages/walkfinishingPage.dart';
import 'package:walk_log/security/securityClass.dart';

import '../pages/homePage.dart';

class FirebaseFunction {
  static addCheckPoints(DateTime checkpointTime, double checkpointValue) async {
    String userId = await SecurityClass.getUserId();
    final checkpoint = CheckPointModel(
            userId: userId,
            checkpointTime: checkpointTime,
            checkpoint: checkpointValue)
        .toJson();

    FirebaseFirestore.instance
        .collection("checkpoints")
        .add(checkpoint)
        .then((value) {})
        .onError((error, stackTrace) =>
            SnackBarUtility.showSnackBar(error.toString()));
  }

  static addCompletion(DateTime checkpointTime, double checkpointValue) async {
    String userId = await SecurityClass.getUserId();
    final checkpoint = CheckPointModel(
            userId: userId,
            checkpointTime: checkpointTime,
            checkpoint: checkpointValue)
        .toJson();

    FirebaseFirestore.instance.collection("completed").add(checkpoint).then(
        (value) {
      Get.to(() => WalkFinishPage(target: checkpointValue));
    }).onError(
        (error, stackTrace) => SnackBarUtility.showSnackBar(error.toString()));
  }

  static totalCompletedTarget() async {
    final now = DateTime.now();
    final last24Hours = now.subtract(Duration(hours: 24));
    String userId = await SecurityClass.getUserId();
    int count = 0;
    await FirebaseFirestore.instance
        .collection("completed")
        .where("userId", isEqualTo: userId)
        .where("checkpointTime", isGreaterThanOrEqualTo: last24Hours)
        .get()
        .then((value) {
      count = value.docs.length;
    });
    return count;
  }
}
