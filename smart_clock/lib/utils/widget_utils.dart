import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class WidgetUtils {
  ///Get weather icon based on weather condition
  static IconData getWeatherIcon(WeatherCondition weatherCondition) {
    assert(weatherCondition != null, "Weather condition can't be null!");
    switch (weatherCondition) {
      case WeatherCondition.cloudy:
        return MdiIcons.weatherCloudy;
      case WeatherCondition.foggy:
        return MdiIcons.weatherFog;
      case WeatherCondition.rainy:
        return MdiIcons.weatherRainy;
      case WeatherCondition.snowy:
        return MdiIcons.weatherSnowy;
      case WeatherCondition.sunny:
        return MdiIcons.weatherSunny;
      case WeatherCondition.thunderstorm:
        return MdiIcons.weatherLightning;
      case WeatherCondition.windy:
        return MdiIcons.weatherWindy;
    }

    return MdiIcons.weatherWindy;
  }

  ///Get gradient colors list based on hour. It returns different gradient
  ///colors for dusk/dawn/midnight/day.
  static List<Color> getGradientColorsBasedOnHour(int hour) {
    assert(hour != null, "Hour can't be null");
    assert(hour >= 0 && hour <= 24, "Hour must be between 0 and 24");
    List<Color> colors = List();
    //night
    if (hour >= 22 || hour <= 5) {
      colors.add(Color.fromARGB(255, 55, 59, 68));
      colors.add(Color.fromARGB(255, 66, 134, 244));
    }
    //sunrise
    if (hour >= 6 && hour <= 9) {
      colors.add(Color.fromARGB(255, 253, 29, 29));
      colors.add(Color.fromARGB(255, 252, 176, 69));
    }
    //day
    if (hour >= 10 && hour <= 18) {
      colors.add(Color.fromARGB(255, 58, 123, 213));
      colors.add(Color.fromARGB(255, 58, 96, 115));
    }
    //sunset
    if (hour >= 19 && hour <= 21) {
      colors.add(Color.fromARGB(255, 11, 72, 107));
      colors.add(Color.fromARGB(255, 245, 98, 23));
    }

    return colors;
  }
}
