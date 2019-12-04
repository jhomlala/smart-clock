import 'package:flutter/material.dart';
import 'package:smart_clock/utils/date_time_utils.dart';

///Widget to display time. It can display time in 24h or 12h format.
class TimeText extends StatelessWidget {
  static const timeAm = "AM";
  static const timePm = "PM";

  /// 24hour format flag
  final bool is24hourFormat;

  ///DateTime to display
  final DateTime dateTime;

  ///Time font size
  final double timeFontSize;

  ///Padding between time text and "AM/PM"  text
  final double padding;

  const TimeText(
      {Key key,
      this.is24hourFormat,
      this.dateTime,
      this.timeFontSize,
      this.padding = 0})
      : assert(is24hourFormat != null, "Flag can't be null"),
        assert(dateTime != null, "Date time can't be null"),
        assert(timeFontSize > 0, " Time font size must be greater than 0"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var hourSuffix = timeAm;
    if (!is24hourFormat) {
      hourSuffix = timePm;
    }

    List<Widget> widgets = List();
    widgets.add(Text(DateTimeUtils.formatTime(dateTime, is24hourFormat),
        style: TextStyle(fontSize: timeFontSize)));
    widgets.add(Padding(
      padding: EdgeInsets.only(left: padding),
    ));
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
