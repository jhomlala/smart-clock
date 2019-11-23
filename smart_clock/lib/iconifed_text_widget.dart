import 'package:flutter/material.dart';

class IconifiedTextWidget extends StatelessWidget {
  final String text;
  final IconData iconData;
  final TextStyle textStyle;
  final Color iconColor;
  final double iconSize;

  const IconifiedTextWidget(
      {Key key,
      this.text,
      this.iconData,
      this.textStyle,
      this.iconColor,
      this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        iconData,
        color: iconColor,
        size: iconSize,
      ),
      Padding(padding: EdgeInsets.only(left:10),),
      Text(
        text,
        style: textStyle,
      )
    ]);
  }
}
