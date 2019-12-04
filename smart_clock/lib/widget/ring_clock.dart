import 'package:flutter/material.dart';
import 'package:smart_clock/widget/time_text.dart';

import '../utils/date_time_utils.dart';
import 'arc_progress_widget.dart';

///Widget to display digital clock, that shows time and date. It shows ring
///for hours, minutes and seconds. Full ring is equal to complete day/hour/minute.
class RingClock extends StatelessWidget {
  static const timeAm = "AM";
  static const timePm = "PM";

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

  ///Ring stroke width
  final double ringStrokeWidth;

  ///Ring animation time in milliseconds
  final int animationTime;

  const RingClock(
      {Key key,
      this.hourRingSize,
      this.minuteRingSize,
      this.secondRingSize,
      this.dateTime,
      this.is24hourFormat,
      this.timeFontSize,
      this.dateFontSize,
      this.ringStrokeWidth,
      this.animationTime})
      : assert(hourRingSize != null && hourRingSize > 0,
            "Hour ring size must be not null and greater than 0"),
        assert(minuteRingSize != null && minuteRingSize > 0,
            "Minute ring size must be not null and greater than 0"),
        assert(secondRingSize != null && secondRingSize > 0,
            "Second ring size must be not null and greater than 0"),
        assert(dateTime != null, "Date time can't be null"),
        assert(
          is24hourFormat != null,
          "Flag can't be null",
        ),
        assert(timeFontSize != null && timeFontSize > 0,
            "Time font size must be not null and greater than 0"),
        assert(dateFontSize != null && dateFontSize > 0,
            "Date font size must be not null and greater than 0"),
        assert(ringStrokeWidth != null && ringStrokeWidth > 0,
            "Ring stroke width must be not null and greater than 0"),
        assert(animationTime != null && animationTime > 0,
            "Animation time must be not null and greater than 0"),
        super(key: key);

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
                    TimeText(
                        dateTime: dateTime,
                        is24hourFormat: is24hourFormat,
                        timeFontSize: timeFontSize),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        DateTimeUtils.formatDate(dateTime),
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
                    strokeWidth: ringStrokeWidth,
                    animationTime: animationTime,
                  ))),
          Center(
              child: Container(
                  width: minuteRingSize,
                  height: minuteRingSize,
                  child: ArcProgressWidget(
                    progressValue: _getMinuteProgress(),
                    boxWidth: minuteRingSize / 2,
                    brightness: Theme.of(context).brightness,
                    strokeWidth: ringStrokeWidth,
                    animationTime: animationTime,
                  ))),
          Center(
              child: Container(
                  width: secondRingSize,
                  height: secondRingSize,
                  child: ArcProgressWidget(
                    progressValue: _getSecondProgress(),
                    boxWidth: secondRingSize / 2,
                    brightness: Theme.of(context).brightness,
                    strokeWidth: ringStrokeWidth,
                    animationTime: animationTime,
                  )))
        ]));
  }

  ///Get current hour progress for ring. It returns percent from 0 to 100 which
  ///shows state of current day.
  double _getHourProgress() {
    return dateTime.hour / 24 * 100;
  }

  ///Get current minute progress. It shows hour progress from 0 to 100 percent.
  double _getMinuteProgress() {
    return dateTime.minute / 60 * 100;
  }

  ///Get current second progress. It shows minute progress from 0 to 100 percent.
  double _getSecondProgress() {
    return dateTime.second / 60 * 100;
  }
}
