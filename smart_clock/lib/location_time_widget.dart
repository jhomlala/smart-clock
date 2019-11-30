import 'package:flutter/material.dart';

import 'date_time_utils.dart';

/// LocationTimeWidget is widget used to display current time/date in given
/// location. It uses time offset to calculate time in given location.
class LocationTimeWidget extends StatelessWidget {
  /// Name of the location. This name will be displayed above time and date.
  final String location;

  /// Time offset based on GMT. Value can be positive and negative. For example,
  /// New York time offset is -5 GMT, so timeOffset will be -5. Tokyo is +8 GMT,
  /// so timeOffset will be 8.
  final int timeOffset;

  /// Font size of time. This size will be used to determine size of other texts.
  final double timeFontSize;

  const LocationTimeWidget(
      {Key key, this.location, this.timeOffset, this.timeFontSize = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime locationDateTime = _getLocationDateTime();
    double otherTextsFontSize = timeFontSize * 0.6;

    return Column(children: [
      Text(
        location,
        style: _getTextStyle(otherTextsFontSize),
      ),
      Text(_formatTime(locationDateTime), style: _getTextStyle(timeFontSize)),
      Text(DateTimeUtils.formatDate(locationDateTime),
          style: _getTextStyle(otherTextsFontSize))
    ]);
  }

  /// Create text style for each text. New TextStyle is created with given
  /// font size.
  TextStyle _getTextStyle(double fontSize) {
    return TextStyle(fontSize: fontSize);
  }

  /// Get location date time. It calculates date time in location based on GMT.
  DateTime _getLocationDateTime() {
    DateTime currentDateTime = DateTime.now();
    Duration timeZoneOffset = currentDateTime.timeZoneOffset;
    currentDateTime = currentDateTime.add(-timeZoneOffset);
    DateTime cityDateTime = currentDateTime.add(Duration(hours: timeOffset));
    return cityDateTime;
  }

  /// Format time for given date time.
  String _formatTime(DateTime dateTime) {
    return DateTimeUtils.formatDateTimeUnit(dateTime.hour, 2) +
        ":" +
        DateTimeUtils.formatDateTimeUnit(dateTime.minute, 2) +
        ":" +
        DateTimeUtils.formatDateTimeUnit(dateTime.second, 2);
  }
}
