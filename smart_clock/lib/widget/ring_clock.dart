import 'package:flutter/material.dart';

import 'arc_progress_widget.dart';

class RingClock extends StatelessWidget {
  final double hourRingSize;
  final double minuteRingSize;
  final double secondRingSize;
  final DateTime dateTime;
  final bool is24hourFormat;
  final String time;
  final double timeFontSize;
  final double dateFontSize;

  const RingClock(
      {Key key,
      this.hourRingSize,
      this.minuteRingSize,
      this.secondRingSize,
      this.dateTime,
      this.is24hourFormat,
      this.time,
      this.timeFontSize,
      this.dateFontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
          padding: EdgeInsets.only(top: 0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
    ]);
  }

  Widget _getTimeWidget(BuildContext context) {
    var hour = dateTime.hour;
    var hourSufix = "AM";
    if (!is24hourFormat) {
      hourSufix = "PM";
    }
    List<Widget> widgets = List();
    widgets.add(Text(time,
        style: TextStyle(
            fontSize: timeFontSize,
            color: Theme.of(context).textTheme.body1.color)));
    if (!is24hourFormat) {
      widgets.add(Text(hourSufix,
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
}
