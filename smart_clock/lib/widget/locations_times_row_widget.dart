import 'package:flutter/material.dart';

import '../model/location.dart';
import 'location_time_widget.dart';

///Widget used to display multiple LocationTimeWidgets. Widgets are displayed in
///a row.
class LocationsTimesRowWidget extends StatelessWidget {
  ///Font size for LocationTimeWidget
  final double fontSize;

  /// List of locations to display in a row
  final List<Location> locations;

  /// 24hour format flag
  final bool is24hourFormat;

  const LocationsTimesRowWidget(
      {Key key, this.fontSize, this.locations, this.is24hourFormat})
      : assert(fontSize > 0, "Font size must be positive"),
        assert(
            locations != null && locations.length > 0 && locations.length <= 5,
            "Locations must be filled. Locations must have max 5 elements."),
        assert(is24hourFormat != null, "Flag can't be null"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildLocationTimeWidgets());
  }

  /// Build list of LocationTimeWidgets based on locations list provided in a
  /// constructor. Each LocationTimeWidget is wrapped in a Padding to add
  /// better spacing.
  List<Widget> _buildLocationTimeWidgets() {
    List<Widget> widgets = List();
    locations.forEach((locationData) {
      widgets.add(Padding(
        child: LocationTimeWidget(
          location: locationData.name,
          timeOffset: locationData.timeOffset,
          timeFontSize: fontSize,
          is24hourFormat: is24hourFormat,
        ),
        padding: EdgeInsets.only(left: 5, right: 5),
      ));
    });
    return widgets;
  }
}
