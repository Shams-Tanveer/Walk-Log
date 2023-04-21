import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'database/hisotryDatabase.dart';
import 'model/historyModel.dart';

class CheckMode extends StatefulWidget {
  const CheckMode({super.key});

  @override
  State<CheckMode> createState() => _CheckModeState();
}

class _CheckModeState extends State<CheckMode> with WidgetsBindingObserver {
  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();
    loadData();
    WidgetsBinding.instance.addObserver(this);
  }

  loadData() async {
    print("called");
    List<History> historyList = await HistoryDatabase.instance.readAll();
    for (var history in historyList) {
      print(history.date);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _isInForeground = true;
        print(_isInForeground);
      });
    } else {
      setState(() {
        _isInForeground = false;
        print(_isInForeground);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foreground vs Background Demo'),
      ),
      body: Center(
        child: Text(
            _isInForeground ? 'App is in foreground' : 'App is in background'),
      ),
    );
  }
}
