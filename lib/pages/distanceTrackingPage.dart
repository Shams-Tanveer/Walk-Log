import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class DistanceTracking extends StatefulWidget {
  final int target;
  const DistanceTracking({Key? key, required this.target}) : super(key: key);

  @override
  State<DistanceTracking> createState() => _DistanceTrackingState();
}

class _DistanceTrackingState extends State<DistanceTracking>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<Position> _positionStreamSubscription;
  double _totalDistance = 0.0;
  Position? _lastPosition;
  late AnimationController _animationController;
  double _progressValue = 0.0;
  List checkpoints = [];
  double _lastCheckpoint  = 0.0;
  double value = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _startTracking();
  }

  @override
  void dispose() {
    super.dispose();
    _stopTracking();
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  Future<void> _startTracking() async {
    try {
      await Geolocator.requestPermission();
      _positionStreamSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (position) {
          if (_lastPosition != null) {
            double distance = Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              position.latitude,
              position.longitude,
            );
            setState(() {
              _totalDistance += distance;
              if (_totalDistance >= widget.target) {
                _animationController.stop();
                _stopTracking();
                _progressValue = 1;
                _totalDistance = widget.target.toDouble();
              } else {
                _progressValue = (_totalDistance / widget.target);
              }
            });
          }
          _lastPosition = position;
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void _stopTracking() {
    _positionStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LiquidCustomProgressIndicator(
              value: _progressValue, // Defaults to 0.5.
              valueColor: AlwaysStoppedAnimation(
                  Colors.pink), // Defaults to the current Theme's accentColor.
              backgroundColor: Colors.white,
              direction: Axis.vertical,
              shapePath: _buildHeartPath(170, 120),
              center: Text('${(_progressValue * 100).toInt().toString()}%'),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Covered Distance:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${_totalDistance.toInt().toString()} m',
                      style: TextStyle(fontSize: 28),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Total Distance:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${widget.target.toInt().toString()} m',
                      style: TextStyle(fontSize: 28),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: checkpoints.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      color: Colors.amber,
                      child: Center(child: Text('${checkpoints[index].toInt().toString()} m')),
                    );
                  }),
            ),
            Container(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    
                    value = _totalDistance -_lastCheckpoint;
                    _lastCheckpoint =  _totalDistance;
                    checkpoints.add(value);
                  });
                },
                child: Text(
                  'Add Checkpoint',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  elevation: MaterialStateProperty.all<double>(5),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  Path _buildHeartPath(double width, double height) {
    return Path()
      ..moveTo(60.5 * width / 116, 22 * height / 79.75)
      ..cubicTo(60.5 * width / 116, 8.25 * height / 79.75, 52.25 * width / 116,
          0, 38.5 * width / 116, 0)
      ..cubicTo(19.25 * width / 116, 0, 5 * width / 116, 16.5 * height / 79.75,
          5 * width / 116, 35.75 * height / 79.75)
      ..cubicTo(5 * width / 116, 50 * height / 79.75, 16.5 * width / 116,
          66 * height / 79.75, 30.25 * width / 116, 79.75 * height / 79.75)
      ..lineTo(60.5 * width / 116, 110 * height / 79.75)
      ..lineTo(90.75 * width / 116, 79.75 * height / 79.75)
      ..cubicTo(104.5 * width / 116, 66 * height / 79.75, 116 * width / 116,
          50 * height / 79.75, 116 * width / 116, 35.75 * height / 79.75)
      ..cubicTo(116 * width / 116, 16.5 * height / 79.75, 102.75 * width / 116,
          0, 83.5 * width / 116, 0)
      ..cubicTo(70.25 * width / 116, 0, 60.5 * width / 116,
          8.25 * height / 79.75, 60.5 * width / 116, 22 * height / 79.75)
      ..close();
  }
}
