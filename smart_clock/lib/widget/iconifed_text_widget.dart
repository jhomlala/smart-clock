import 'package:flutter/material.dart';

/// Widget used to display text with icon
class IconifiedTextWidget extends StatelessWidget {
  /// Text to display
  final String text;

  /// Icon to display
  final IconData iconData;

  /// Font size of displayed text
  final double fontSize;

  /// Icon size
  final double iconSize;

  /// Width of whole widget. Used to distribute multiple IconifiedTextWidgets
  /// inside a row.
  final double width;

  const IconifiedTextWidget(
      {Key key,
      this.text,
      this.iconData,
      this.fontSize,
      this.iconSize,
      this.width})
      : assert(text != null && text.length > 0, "Text can't be null or empty"),
        assert(iconData != null, "Icon data can't be null"),
        assert(fontSize != null && fontSize > 0,
            "Font size must be not null and greater than 0"),
        assert(iconSize != null && iconSize > 0,
            "Icon size must be not null and greater than 0"),
        assert(width != null && width > 0,
            "Width must be not null and greater than 0"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            iconData,
            size: iconSize,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Flexible(
              child: Container(
                  child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: fontSize),
          )))
        ]));
  }
}
