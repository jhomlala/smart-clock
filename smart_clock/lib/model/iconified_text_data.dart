import 'package:flutter/cupertino.dart';

///Model class for additional clock data, i.e. home location, temperature, weather.
class IconifiedTextData {
  ///Name of the extra
  final String name;

  ///Icon of the extra
  final IconData iconData;

  ///Is widget big. Big widget will have bigger font and bigger icon
  final bool isBig;

  ///Fraction of screen which will be maximal width of iconified text widget.
  ///Value should be between 0.0 and 1.0
  final double screenWidthFraction;

  IconifiedTextData(this.name, this.iconData, this.isBig,
      this.screenWidthFraction)
      : assert(name != null && name.length > 0, "Name can't be null or empty"),
        assert(iconData != null, "Icon data can't be null"),
        assert(screenWidthFraction >= 0 &&
            screenWidthFraction <= 1, "Screen width should be between 0 and 1");
}
