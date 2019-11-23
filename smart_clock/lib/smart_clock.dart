import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_clock/sun_path_widget.dart';

class SmartClock extends StatefulWidget {
  @override
  _SmartClockState createState() => _SmartClockState();
}

class _SmartClockState extends State<SmartClock> {
  Timer _timer;
  String _time = "";
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 10), _updateTime);
    _dateTime = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.6],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Color.fromARGB(255, 20, 136, 204),
              Color.fromARGB(255, 43, 50, 178)
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                  child: Text(
                _time,
                style: TextStyle(fontSize: 120, color: Colors.white),
              )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  _formatDate(),
                  style: TextStyle(fontSize: 60, color: Colors.white),
                )
              ])
            ]),
            Center(
                child: SunPathWidget(
                    progressValue: _getSecondProgress(),
                    left: -100,
                    top: -190,
                    width: 500,
                    height: 500)),
            Center(
                child: SunPathWidget(
                    progressValue: _getMinuteProgress(),
                    left: -110,
                    top: -200,
                    width: 520,
                    height: 520)),
            Center(
                child: SunPathWidget(
                    progressValue: _getHourProgress(),
                    left: -120,
                    top: -210,
                    width: 540,
                    height: 540))
          ],
        ));
  }

  double _getHourProgress() {
    return _dateTime.hour / 24 * 100;
  }

  double _getMinuteProgress() {
    return _dateTime.minute / 60 * 100;
  }

  double _getSecondProgress() {
    return _dateTime.second / 60 * 100;
  }

  void _updateTime(Timer timer) {
    setState(() {
      //_time = DateTime.now().toIso8601String();
      _dateTime = DateTime.now();
      _time = _formatTimeUnit(_dateTime.hour, 2) +
          ":" +
          _formatTimeUnit(_dateTime.minute, 2) +
          ":" +
          _formatTimeUnit(_dateTime.second, 2); //+
      /*"." +
          _formatTimeUnit(dateTime.millisecond, 3);*/
    });
  }

  String _formatTimeUnit(int value, int places) {
    if (places == 2 && value < 10) {
      return "0$value";
    }
    if (places == 3) {
      if (value < 10) {
        return "00$value";
      }
      if (value < 100) {
        return "0$value";
      }
    }
    return "$value";
  }

  String _formatDate() {
    return "${_dateTime.year}/${_dateTime.month}/${_dateTime.day}";
  }
}
