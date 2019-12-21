class DateTimeUtils {

  ///Format date time unit with 0 or 00 before.
  static String formatDateTimeUnit(int value, int places) {
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

  ///Format date string from DateTime object
  static String formatDate(DateTime dateTime) {
    return "${dateTime.year}/${formatDateTimeUnit(dateTime.month, 2)}/${formatDateTimeUnit(dateTime.day, 2)}";
  }

  ///Format time string from DateTime object. It offers option to format in 12 or 24 h clock format.
  static String formatTime(DateTime dateTime, bool is24hourFormat) {
    var hour = dateTime.hour;
    if (!is24hourFormat) {
      if (hour > 12) {
        hour = hour - 12;
      }
    }
    return DateTimeUtils.formatDateTimeUnit(hour, 2) +
        ":" +
        DateTimeUtils.formatDateTimeUnit(dateTime.minute, 2) +
        ":" +
        DateTimeUtils.formatDateTimeUnit(dateTime.second, 2);
  }
}
