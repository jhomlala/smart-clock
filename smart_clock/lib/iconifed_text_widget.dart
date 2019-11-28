import 'package:flutter/material.dart';

class IconifiedTextWidget extends StatelessWidget {
  final String text;
  final IconData iconData;
  final TextStyle textStyle;
  final Color iconColor;
  final double iconSize;
  final double width;

  const IconifiedTextWidget(
      {Key key,
      this.text,
      this.iconData,
      this.textStyle,
      this.iconColor,
      this.iconSize,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Icon(
            iconData,
            color: iconColor,
            size: iconSize,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Flexible(child: Container(child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          )))
        ]));
  }
}
