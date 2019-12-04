import 'package:flutter/material.dart';
import 'package:smart_clock/utils/date_time_utils.dart';

class TimeText extends StatelessWidget {
  static const timeAm = "AM";
  static const timePm = "PM";

  final bool is24hourFormat;
  final DateTime dateTime;
  final double timeFontSize;
  final double padding;

  const TimeText(
      {Key key, this.is24hourFormat, this.dateTime, this.timeFontSize, this.padding = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hourSuffix = timeAm;
    if (!is24hourFormat) {
      hourSuffix = timePm;
    }
    String time = DateTimeUtils.formatTime(dateTime, is24hourFormat);
    List<Widget> widgets = List();
    widgets.add(Text(time, style: TextStyle(fontSize: timeFontSize)));
    widgets.add(Padding(padding: EdgeInsets.only(left:padding),));
    if (!is24hourFormat) {
      widgets.add(Text(hourSuffix,
          style: TextStyle(
            fontSize: timeFontSize / 2,
          )));
    }
    return Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: widgets));
  }
}
