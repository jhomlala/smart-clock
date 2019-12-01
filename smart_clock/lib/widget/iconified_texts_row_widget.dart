import 'package:flutter/material.dart';
import 'package:smart_clock/model/iconified_text_data.dart';

import 'iconifed_text_widget.dart';

/// Widget used to display multiple iconified text rows.
class IconifiedTextsRowWidget extends StatelessWidget {
  ///Data of iconified texts
  final List<IconifiedTextData> iconifiedTextData;

  ///Small element font (and icon) size
  final double smallFontSize;

  ///Big element font (and icon) size
  final double bigFontSize;

  const IconifiedTextsRowWidget(
      {Key key, this.iconifiedTextData, this.smallFontSize, this.bigFontSize})
      : assert(
            iconifiedTextData != null &&
                iconifiedTextData.length != 0 &&
                iconifiedTextData.length <= 3,
            "Iconified data can't be null and size must be between 1 and 3"),
        assert(smallFontSize > 0, "Small font size should have positive value"),
        assert(bigFontSize > 0, "Big font size should have positive value"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _getIconifiedTextsWidgets(context),
    );
  }

  /// Build iconified texts widgets based on passed data
  List<Widget> _getIconifiedTextsWidgets(BuildContext context) {
    List<Widget> widgets = new List();
    double screenWidth = MediaQuery.of(context).size.width;
    iconifiedTextData.forEach((data) {
      double fontSize = smallFontSize;
      if (data.isBig) {
        fontSize = bigFontSize;
      }

      widgets.add(IconifiedTextWidget(
        text: data.name,
        iconData: data.iconData,
        fontSize: fontSize,
        iconSize: fontSize,
        width: screenWidth * data.screenWidthFraction,
      ));
    });
    return widgets;
  }
}
