import 'package:flutter/material.dart';

import '../date_time_utils.dart';
import 'arc_progress_widget.dart';


///Widget to display digital clock, that shows time and date. It shows ring
///for hours, minutes and seconds. Full ring is equal to complete day/hour/minute.
class RingClock extends StatelessWidget {

  ///Size of hour ring. It's the smallest ring
  final double hourRingSize;

  ///Size of minute ring. It's the ring in the middle
  final double minuteRingSize;

  ///Size of second ring. It's the biggest ring (outer ring)
  final double secondRingSize;

  ///Current dateTime
  final DateTime dateTime;

  ///Should time be shown in 24 hours format
  final bool is24hourFormat;

  ///Time text font size
  final double timeFontSize;

  ///Date text font size
  final double dateFontSize;

  const RingClock(
      {Key key,
      this.hourRingSize,
      this.minuteRingSize,
      this.secondRingSize,
      this.dateTime,
      this.is24hourFormat,
      this.timeFontSize,
      this.dateFontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: secondRingSize,
        width: secondRingSize,
        child: Stack(children: [
          Padding(
              padding: EdgeInsets.only(top: 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _getTimeWidget(context),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        _formatDate(),
                        style: TextStyle(
                            fontSize: dateFontSize,
                            color: Theme.of(context).textTheme.body1.color),
                      )
                    ])
                  ])),
          Center(
              child: Container(
                  width: hourRingSize,
                  height: hourRingSize,
                  child: ArcProgressWidget(
                    progressValue: _getHourProgress(),
                    boxWidth: hourRingSize / 2,
                    brightness: Theme.of(context).brightness,
                    strokeWidth: 10,
                    animationTime: 500,
                  ))),
          Center(
              child: Container(
                  width: minuteRingSize,
                  height: minuteRingSize,
                  child: ArcProgressWidget(
                    progressValue: _getMinuteProgress(),
                    boxWidth: minuteRingSize / 2,
                    brightness: Theme.of(context).brightness,
                    strokeWidth: 10,
                    animationTime: 500,
                  ))),
          Center(
              child: Container(
                  width: secondRingSize,
                  height: secondRingSize,
                  child: ArcProgressWidget(
                    progressValue: _getSecondProgress(),
                    boxWidth: secondRingSize / 2,
                    brightness: Theme.of(context).brightness,
                    strokeWidth: 10,
                    animationTime: 500,
                  )))
        ]));
  }

  Widget _getTimeWidget(BuildContext context) {
    var hour = dateTime.hour;
    var hourSuffix = "AM";
    if (!is24hourFormat) {
      hourSuffix = "PM";
    }
    String time = _formatTime();
    List<Widget> widgets = List();
    widgets.add(Text(time,
        style: TextStyle(
            fontSize: timeFontSize,
            color: Theme.of(context).textTheme.body1.color)));
    if (!is24hourFormat) {
      widgets.add(Text(hourSuffix,
          style: TextStyle(
              fontSize: timeFontSize / 2,
              color: Theme.of(context).textTheme.body1.color)));
    }
    return Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: widgets));
  }

  String _formatDate() {
    return "${dateTime.year}/${dateTime.month}/${dateTime.day}";
  }

  double _getHourProgress() {
    return dateTime.hour / 24 * 100;
  }

  double _getMinuteProgress() {
    return dateTime.minute / 60 * 100;
  }

  double _getSecondProgress() {
    return dateTime.second / 60 * 100;
  }

  String _formatTime(){
    var hour = dateTime.hour;
    var hourSufix = "AM";
    if (!is24hourFormat) {
      if (hour > 12) {
        hour = hour - 12;
      }
      hourSufix = "PM";
    }
    return DateTimeUtils.formatDateTimeUnit(hour, 2) +
        ":" +
        DateTimeUtils.formatDateTimeUnit(dateTime.minute, 2) +
        ":" +
        DateTimeUtils.formatDateTimeUnit(dateTime.second, 2);
  }
}
