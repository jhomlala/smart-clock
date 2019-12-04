import 'package:flutter/material.dart';
import 'package:smart_clock/widget/time_text.dart';

import '../utils/date_time_utils.dart';

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
  /// Default value is 20.
  final double timeFontSize;

  final bool is24hourFormat;

  const LocationTimeWidget(
      {Key key,
      this.location,
      this.timeOffset,
      this.timeFontSize = 20,
      this.is24hourFormat})
      : assert(location != null && location.length > 0,
            "Location should not be empty or null"),
        assert(timeOffset >= -12 && timeOffset <= 12,
            "TimeOffset should be between -12 and 12"),
        assert(timeFontSize != null && timeFontSize > 0,
            "TimeFontSize must be not null and greater than 0"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime locationDateTime = _getLocationDateTime();
    double otherTextsFontSize = timeFontSize * 0.6;

    return Column(children: [
      Text(
        location,
        style: _getTextStyle(otherTextsFontSize),
      ),
      TimeText(
        dateTime: locationDateTime,
        timeFontSize: timeFontSize,
        is24hourFormat: is24hourFormat,
        padding: 5,
      ),
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
}
