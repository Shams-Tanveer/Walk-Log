//import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
//import 'package:walk_log/notification/notificationClass.dart';
//
//class CheckingNofication extends StatefulWidget {
//  const CheckingNofication({super.key});
//
//  @override
//  State<CheckingNofication> createState() => _CheckingNoficationState();
//}
//
//class _CheckingNoficationState extends State<CheckingNofication> {
//
//  NotificationClass _notificationClass = NotificationClass();
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _notificationClass.initializeNotification();
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: ElevatedButton(
//        onPressed: (){
//          _notificationClass.sendNotifcation("title", "body", "payLoad");
//        },
//        child: Text("Click")),
//    );
//  }
//}



import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walk_log/permission/permissionHandler.dart';

class MyLocationScreen extends StatefulWidget {
  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  PermissionStatus? _permissionStatus;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  call()async{
    await PermissionHandler.handleBackgroundLocationPermission(context);
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.activityRecognition.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> _requestPermission() async {
    print("Calling");
    final result = await Permission.activityRecognition.request();
    print(result);
    setState(() {
      _permissionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_permissionStatus == PermissionStatus.granted)
              Text('Location permission granted'),
            if (_permissionStatus == PermissionStatus.denied ||
                _permissionStatus == PermissionStatus.restricted)
              Text('Location permission denied'),
            if (_permissionStatus == PermissionStatus.permanentlyDenied)
              Text('Location permission permanently denied'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Allow Location'),
              onPressed: () {
                PermissionHandler.handleActivityRecognitionPermission();
              },
            ),
          ],
        ),
      ),
    );
  }
}
