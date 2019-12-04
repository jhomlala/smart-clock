import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:smart_clock/model/iconified_text_data.dart';
import 'package:smart_clock/widget/iconified_texts_row_widget.dart';
import 'package:smart_clock/widget/locations_times_row_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_clock/widget/ring_clock.dart';
import 'package:smart_clock/utils/widget_utils.dart';
import '../model/location.dart';

///Main widget that displays clock in multiple locations, ring clock and additional
///bottom information, like location, temperature and weather. SmartClock requires
///ClockModel provided by constructor.
class SmartClock extends StatefulWidget {
  final ClockModel clockModel;

  const SmartClock({Key key, this.clockModel}) : super(key: key);

  @override
  _SmartClockState createState() => _SmartClockState();
}

class _SmartClockState extends State<SmartClock> {
  ///SmartClock refresh time in milliseconds
  static const int _timerUpdateTime = 100;

  ///Timer object, so it can be disposed later, once widget is disposed
  Timer _timer;

  ///Current dateTime, used to setup multiple widgets
  DateTime _dateTime;

  ///Clock model accessor, it's only syntax sugar :)
  ClockModel get _clockModel => widget.clockModel;

  ///Hour ring size for ring clock
  double _hourRingSize;

  ///Minute ring size for ring clock
  double _minuteRingSize;

  ///Second ring size for ring clock
  double _secondRingSize;

  ///Text size of time in ring clock
  double _timeFontSize;

  ///Text size of date in ring clock
  double _dateFontSize;

  ///Top locations text size
  double _locationTimeFontSize;

  ///Bottom elements small text size
  double _iconifiedSmallTextFontSize;

  ///Bottom elements big text size
  double _iconifiedBigTextFontSize;

  ///Init timer and get first dateTime
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        Duration(milliseconds: _timerUpdateTime), _updateDateTime);
    _dateTime = DateTime.now();
  }

  ///Dispose timer, so it won't run infinitely
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  ///Setup all necessary fields for smart clock. It is required to have filled
  ///context here, so we couldn't do it in initState. Did change dependencies run
  ///once dependencies changed(and run before build) so this place is perfect to
  ///setup all fields.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    double height = MediaQuery.of(context).size.height;
    _hourRingSize = _getHourRingSize(height);
    _minuteRingSize = _getMinuteRingSize(_hourRingSize);
    _secondRingSize = _getSecondRingSize(_hourRingSize);
    _timeFontSize = _getTimeFontSize(_hourRingSize);
    _dateFontSize = _getDateFontSize(_hourRingSize);
    _locationTimeFontSize = _getLocationTimeFontSize(_hourRingSize);
    _iconifiedBigTextFontSize = _getIconifiedBigTextFontSize(_hourRingSize);
    _iconifiedSmallTextFontSize = _getIconifiedSmallTextFontSize(_hourRingSize);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: _getGradient()),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: RingClock(
                  hourRingSize: _hourRingSize,
                  minuteRingSize: _minuteRingSize,
                  secondRingSize: _secondRingSize,
                  dateTime: _dateTime,
                  is24hourFormat: _clockModel.is24HourFormat,
                  timeFontSize: _timeFontSize,
                  dateFontSize: _dateFontSize,
                  ringStrokeWidth: 10,
                  animationTime: 500,
                )),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: LocationsTimesRowWidget(
                      fontSize: _locationTimeFontSize,
                      locations: _getLocations(),
                      is24hourFormat: _clockModel.is24HourFormat,
                    ))),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: IconifiedTextsRowWidget(
                    iconifiedTextData: _getIconifiedTextData(),
                    smallFontSize: _iconifiedSmallTextFontSize,
                    bigFontSize: _iconifiedBigTextFontSize,
                  ),
                )),
          ],
        ));
  }

  ///Update date time in each timer cycle
  void _updateDateTime(Timer timer) {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  ///Get bottom elements to display
  List<IconifiedTextData> _getIconifiedTextData() {
    List<IconifiedTextData> data = List();
    data.add(IconifiedTextData(
        _clockModel.temperatureString, MdiIcons.thermometer, false, 0.3));
    data.add(IconifiedTextData(_clockModel.location, MdiIcons.home, true, 0.4));
    data.add(IconifiedTextData(_capitalize(_clockModel.weatherString),
        WidgetUtils.getWeatherIcon(_clockModel.weatherCondition), false, 0.3));

    return data;
  }

  ///Get smart clock background gradient
  LinearGradient _getGradient() {
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [0.1, 0.9],
      colors: WidgetUtils.getGradientColorsBasedOnHour(_dateTime.hour),
    );
  }

  ///Get all locations to display at the top of the screen
  List<Location> _getLocations() {
    List<Location> locations = List();
    locations.add(Location("New York", -5));
    locations.add(Location("Berlin", 1));
    locations.add(Location("Warsaw", 1));
    locations.add(Location("Moscow", 3));
    locations.add(Location("Tokyo", 8));

    return locations;
  }

  ///Capitalize first letter of string
  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  ///Calculate time font size for ring clock
  double _getTimeFontSize(double hourRingSize) {
    if (_clockModel.is24HourFormat) {
      return hourRingSize / 5;
    } else {
      return hourRingSize / 6;
    }
  }

  ///Calculate date font size for ring clock
  double _getDateFontSize(double hourRingSize) {
    return hourRingSize / 10;
  }

  ///Calculate location elements font size
  double _getLocationTimeFontSize(double hourRingSize) {
    return hourRingSize / 14;
  }

  ///Calculate small text font size for bottom elements
  double _getIconifiedSmallTextFontSize(double hourRingSize) {
    return hourRingSize / 14;
  }

  ///Calculate big text font size for bottom elements
  double _getIconifiedBigTextFontSize(double hourRingSize) {
    return hourRingSize / 10;
  }

  ///Calculate hour ring size based on screen height
  double _getHourRingSize(double screenHeight) {
    return screenHeight * 0.5;
  }

  ///Calculate minute ring size based on hour ring size
  double _getMinuteRingSize(double hourRingSize) {
    return hourRingSize + 25;
  }

  ///Calculate second ring size based on hour ring size
  double _getSecondRingSize(double hourRingSize) {
    return hourRingSize + 50;
  }
}
