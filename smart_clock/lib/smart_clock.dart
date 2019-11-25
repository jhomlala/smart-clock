import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:smart_clock/city_digital_clock.dart';
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
          gradient:_getGradient()
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CityDigitalClock(
                            city: "New York",
                            timeOffset: -5,
                          ),
                          CityDigitalClock(
                            city: "Berlin",
                            timeOffset: 1,
                          ),
                          CityDigitalClock(
                            city: "Warsaw",
                            timeOffset: 1,
                          ),
                          CityDigitalClock(
                            city: "Moscow",
                            timeOffset: 3,
                          ),
                          CityDigitalClock(
                            city: "Tokyo",
                            timeOffset: 9,
                          )
                        ]))),
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
                                TextStyle(color: Colors.white, fontSize: 40),
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

  LinearGradient _getGradient() {
    return LinearGradient(
      // Where the linear gradient begins and ends
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: [0.1, 0.9],
      colors: _getGradientColors(),
    );
  }

  List<Color> _getGradientColors() {
    List<Color> colors = List();
    int hour = _dateTime.hour;
    //night
    if (hour >= 22 || hour <= 5) {
      colors.add(Color.fromARGB(255, 35,37,38));
      colors.add(Color.fromARGB(255, 65,67,69));
    }
    //sunrise
    if (hour >= 6 && hour <= 9) {
      colors.add(Color.fromARGB(255, 253, 29, 29));
      colors.add(Color.fromARGB(255, 252, 176, 69));
    }
    //day
    if (hour >= 10 && hour <= 18) {
      colors.add(Color.fromARGB(255, 58,123,213));
      colors.add(Color.fromARGB(255, 58,96,115));
    }
    //sunset
    if (hour >= 19 && hour <= 21) {
      colors.add(Color.fromARGB(255, 11,72,107));
      colors.add(Color.fromARGB(255, 245,98,23));
    }
    print("colors: " + colors.length.toString());
    return colors;
  }
}
