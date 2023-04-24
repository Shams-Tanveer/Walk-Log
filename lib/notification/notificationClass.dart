import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationClass {
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =AndroidInitializationSettings("walklogblackmin");
  void initializeNotification() async{
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings
    );

   await _notificationPlugin.initialize(initializationSettings);
  }

  sendNotifcation(String title, String body, String payLoad)async{

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      "channelId", "channelName",importance: Importance.max,priority: Priority.high);
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails
    );
    await _notificationPlugin.show(0, title, body, notificationDetails);
  }
}
