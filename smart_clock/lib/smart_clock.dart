import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:smart_clock/iconifed_text_widget.dart';
import 'package:smart_clock/sun_path_widget.dart';

class SmartClock extends StatefulWidget {
  @override
  _SmartClockState createState() => _SmartClockState();
}

class _SmartClockState extends State<SmartClock> {
  Timer _timer;
  String _time = "";
  DateTime _dateTime;
  ClockModel _clockModel;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 10), _updateTime);
    _dateTime = DateTime.now();
    _clockModel = ClockModel();
    _clockModel.addListener(onModelChanged);
    print("Location: " + _clockModel.location);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onModelChanged() {
    print("Model changed!");
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
                child: ArcProgressWidget(
                    progressValue: _getHourProgress(),
                    left: -100,
                    top: -190,
                    width: 500,
                    height: 500)),
            Center(
                child: ArcProgressWidget(
                    progressValue: _getMinuteProgress(),
                    left: -110,
                    top: -200,
                    width: 520,
                    height: 520)),
            Center(
                child: ArcProgressWidget(
                    progressValue: _getSecondProgress(),
                    left: -120,
                    top: -210,
                    width: 540,
                    height: 540)),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(children: [Text(
                      "“In three words I can sum up everything I've learned about life: it goes on.”",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                      Align(child:Text(
                        "Robert Frost",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ))]))),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconifiedTextWidget(
                            text: _clockModel.temperatureString,
                            iconData: Icons.ac_unit,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 30),
                            iconColor: Colors.white,
                            iconSize: 30,
                          ),
                          IconifiedTextWidget(
                            text: _clockModel.location,
                            iconData: Icons.home,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 30),
                            iconColor: Colors.white,
                            iconSize: 30,
                          ),
                          IconifiedTextWidget(
                            text: capitalize(_clockModel.weatherString),
                            iconData: Icons.wb_sunny,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 30),
                            iconColor: Colors.white,
                            iconSize: 30,
                          )
                        ])))
          ],
        ));
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
