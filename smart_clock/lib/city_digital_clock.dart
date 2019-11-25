import 'package:flutter/material.dart';

class CityDigitalClock extends StatelessWidget {
  final String city;
  final int timeOffset;

  const CityDigitalClock({Key key, this.city, this.timeOffset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime cityDateTime = getDateTime();
    return Column(children: [
      Text(
        city,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      Text(_updateTime(cityDateTime), style: TextStyle(fontSize: 24, color: Colors.white)),
      Text(_formatDate(cityDateTime), style: TextStyle(fontSize: 16, color: Colors.white))
    ]);
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

  DateTime getDateTime(){
    DateTime now = DateTime.now();
    Duration timeZoneOffset = now.timeZoneOffset;
    now = now.add(-timeZoneOffset);
    DateTime cityDateTime  = now.add(Duration(hours: timeOffset));
    return cityDateTime;
  }

  String _updateTime(DateTime dateTime) {
      return _formatTimeUnit(dateTime.hour, 2) +
          ":" +
          _formatTimeUnit(dateTime.minute, 2) +
          ":" +
          _formatTimeUnit(dateTime.second, 2);

  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.year}/${dateTime.month}/${dateTime.day}";
  }
}
