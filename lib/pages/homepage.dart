import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _minValue = 0;
  double _maxValue = 10000;

  TextEditingController _minController = TextEditingController();
  TextEditingController _maxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _maxController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Set Limit",
                hoverColor: Colors.red,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red)),
              ),
              onChanged: (value) {
                setState(() {
                  _maxValue = double.parse(value);
                });
              },
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 400,
            child: RangeSlider(
              values: RangeValues(_minValue, _maxValue),
              min: 0,
              max: 10000,
              divisions: 100,
              onChanged: (RangeValues values) {
                setState(() {
                  _maxValue = values.end;
                  _minController.text = _minValue.toStringAsFixed(0);
                  _maxController.text = _maxValue.toStringAsFixed(0);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("0 m"), Text("10000 m")],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // handle button press
            },
            child: Text(
              'Start',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
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
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}
