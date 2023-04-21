import 'dart:isolate';

import 'package:flutter/material.dart';

class BackgroundFunctionDemo extends StatefulWidget {
  @override
  _BackgroundFunctionDemoState createState() => _BackgroundFunctionDemoState();
}

class _BackgroundFunctionDemoState extends State<BackgroundFunctionDemo> {
  String _output = '';

  Future<void> _runBackgroundFunction() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_backgroundFunction, receivePort.sendPort);

    receivePort.listen((data) {
      setState(() {
        _output = data;
      });
    });
  }

  static void _backgroundFunction(SendPort sendPort) async {
    while (true) {
      // perform your long-running task here
      await Future.delayed(Duration(seconds: 15));
      String time = DateTime.now().toString();
      sendPort.send('Background function running at $time');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_output);
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Function Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _runBackgroundFunction,
              child: Text('Run Function in Background'),
            ),
            SizedBox(height: 16),
            Text(_output),
          ],
        ),
      ),
    );
  }
}