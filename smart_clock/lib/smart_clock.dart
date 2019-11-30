import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:smart_clock/location_time_widget.dart';
import 'package:smart_clock/iconifed_text_widget.dart';
import 'package:smart_clock/sun_path_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SmartClock extends StatefulWidget {
  final ClockModel clockModel;

  const SmartClock({Key key, this.clockModel}) : super(key: key);

  @override
  _SmartClockState createState() => _SmartClockState();
}

class _SmartClockState extends State<SmartClock> {
  Timer _timer;
  String _time = "";
  DateTime _dateTime;

  ClockModel get _clockModel => widget.clockModel;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 10), _updateTime);
    _dateTime = DateTime.now();
    _clockModel.addListener(onModelChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void onModelChanged() {
    print("Model changed!");
  }

  double _getTimeFontSize(double hourRingSize) {
    if (_clockModel.is24HourFormat) {
      return hourRingSize / 5;
    } else {
      return hourRingSize / 6;
    }
  }

  double _getDateFontSize(double hourRingSize) {
    return hourRingSize / 10;
  }

  double _getCityClockMaxTextSize(double hourRingSize) {
    return hourRingSize / 14;
  }

  double _getBottomSmallWidgetTextSize(double hourRingSize) {
    return hourRingSize / 14;
  }

  double _getBottomBigWidgetTextSize(double hourRingSize) {
    return hourRingSize / 10;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double screenWidth = width;

    double hourRingSize = height * 0.5;
    double minuteRingSize = hourRingSize + 15;
    double secondRingSize = minuteRingSize + 15;
    //print("ring size: " + ringSize.toString());

    //print("W: " + width.toString() + " height:  " + height.toString());

    return Container(
        decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: _getGradient()),
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _getTimeWidget(hourRingSize),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatDate(),
                              style: TextStyle(
                                  fontSize: _getDateFontSize(hourRingSize),
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                            )
                          ])
                    ])),
            Center(
                child: Container(
                    width: hourRingSize,
                    height: hourRingSize,
                    child: ArcProgressWidget(
                      progressValue: _getHourProgress(),
                      width: hourRingSize / 2,
                      brightness: Theme.of(context).brightness,
                    ))),
            Center(
                child: Container(
                    width: minuteRingSize,
                    height: minuteRingSize,
                    child: ArcProgressWidget(
                      progressValue: _getMinuteProgress(),
                      width: minuteRingSize / 2,
                      brightness: Theme.of(context).brightness,
                    ))),
            Center(
                child: Container(
                    width: secondRingSize,
                    height: secondRingSize,
                    child: ArcProgressWidget(
                      progressValue: _getSecondProgress(),
                      width: secondRingSize / 2,
                      brightness: Theme.of(context).brightness,
                    ))),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LocationTimeWidget(
                            location: "New York",
                            timeOffset: -5,
                            timeFontSize: _getCityClockMaxTextSize(hourRingSize),
                          ),
                          LocationTimeWidget(
                            location: "Berlin",
                            timeOffset: 1,
                            timeFontSize: _getCityClockMaxTextSize(hourRingSize),
                          ),
                          LocationTimeWidget(
                            location: "Warsaw",
                            timeOffset: 1,
                            timeFontSize: _getCityClockMaxTextSize(hourRingSize),
                          ),
                          LocationTimeWidget(
                            location: "Moscow",
                            timeOffset: 3,
                            timeFontSize: _getCityClockMaxTextSize(hourRingSize),
                          ),
                          LocationTimeWidget(
                            location: "Tokyo",
                            timeOffset: 9,
                            timeFontSize: _getCityClockMaxTextSize(hourRingSize),
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
                            iconData: MdiIcons.thermometer,
                            textStyle: TextStyle(
                                color: Theme.of(context).textTheme.body1.color,
                                fontSize: _getBottomSmallWidgetTextSize(
                                    hourRingSize)),
                            iconColor: Theme.of(context).textTheme.body1.color,
                            iconSize:
                                _getBottomSmallWidgetTextSize(hourRingSize),
                            width: screenWidth * 0.3,
                          ),
                          IconifiedTextWidget(
                            text: _clockModel.location,
                            iconData: Icons.home,
                            textStyle: TextStyle(
                                color: Theme.of(context).textTheme.body1.color,
                                fontSize:
                                    _getBottomBigWidgetTextSize(hourRingSize)),
                            iconColor: Theme.of(context).textTheme.body1.color,
                            iconSize: _getBottomBigWidgetTextSize(hourRingSize),
                            width: screenWidth * 0.4,
                          ),
                          IconifiedTextWidget(
                            text: capitalize(_clockModel.weatherString),
                            iconData:
                                _getWeatherIcon(_clockModel.weatherCondition),
                            textStyle: TextStyle(
                                color: Theme.of(context).textTheme.body1.color,
                                fontSize: _getBottomSmallWidgetTextSize(
                                    hourRingSize)),
                            iconColor: Theme.of(context).textTheme.body1.color,
                            iconSize:
                                _getBottomSmallWidgetTextSize(hourRingSize),
                            width: screenWidth * 0.3,
                          )
                        ]))),
          ],
        ));
  }

  Widget _getTimeWidget(double hourRingSize) {
    var is24hourFormat = _clockModel.is24HourFormat;
    var hour = _dateTime.hour;
    var hourSufix = "AM";
    if (!is24hourFormat) {
      hourSufix = "PM";
    }
    List<Widget> widgets = List();
    widgets.add(Text(_time,
        style: TextStyle(
            fontSize: _getTimeFontSize(hourRingSize),
            color: Theme.of(context).textTheme.body1.color)));
    if (!is24hourFormat) {
      widgets.add(Text(hourSufix,
          style: TextStyle(
              fontSize: _getTimeFontSize(hourRingSize) / 2,
              color: Theme.of(context).textTheme.body1.color)));
    }
    return Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: widgets));
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
    var is24hourFormat = _clockModel.is24HourFormat;
    var hour = _dateTime.hour;
    var hourSufix = "AM";
    if (!is24hourFormat) {
      if (hour > 12) {
        hour = hour - 12;
      }
      hourSufix = "PM";
    }
    setState(() {
      //_time = DateTime.now().toIso8601String();
      _dateTime = DateTime.now();
      _time = _formatTimeUnit(hour, 2) +
          ":" +
          _formatTimeUnit(_dateTime.minute, 2) +
          ":" +
          _formatTimeUnit(_dateTime.second, 2);
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
      colors: _getGradientColors(context),
    );
  }

  List<Color> _getGradientColors(BuildContext context) {
    List<Color> colors = List();
    int hour = _dateTime.hour;

      //night
      if (hour >= 22 || hour <= 5) {
        colors.add(Color.fromARGB(255, 55, 59, 68));
        colors.add(Color.fromARGB(255, 66, 134, 244));
      }
      //sunrise
      if (hour >= 6 && hour <= 9) {
        colors.add(Color.fromARGB(255, 253, 29, 29));
        colors.add(Color.fromARGB(255, 252, 176, 69));
      }
      //day
      if (hour >= 10 && hour <= 18) {
        colors.add(Color.fromARGB(255, 58, 123, 213));
        colors.add(Color.fromARGB(255, 58, 96, 115));
      }
      //sunset
      if (hour >= 19 && hour <= 21) {
        colors.add(Color.fromARGB(255, 11, 72, 107));
        colors.add(Color.fromARGB(255, 245, 98, 23));

    }





    return colors;
  }

  IconData _getWeatherIcon(WeatherCondition weatherCondition) {
    switch (weatherCondition) {
      case WeatherCondition.cloudy:
        return MdiIcons.weatherCloudy;
      case WeatherCondition.foggy:
        return MdiIcons.weatherFog;
      case WeatherCondition.rainy:
        return MdiIcons.weatherRainy;
      case WeatherCondition.snowy:
        return MdiIcons.weatherSnowy;
      case WeatherCondition.sunny:
        return MdiIcons.weatherSunny;
      case WeatherCondition.thunderstorm:
        return MdiIcons.weatherLightning;
      case WeatherCondition.windy:
        return MdiIcons.weatherWindy;
    }

    return MdiIcons.weatherWindy;
  }
}
