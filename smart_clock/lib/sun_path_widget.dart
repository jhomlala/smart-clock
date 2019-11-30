import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'animated_state.dart';

class ArcProgressWidget extends StatefulWidget {
  final double progressValue;
  final double left;
  final double top;
  final double width;
  final double height;
  final Brightness brightness;

  ArcProgressWidget(
      {Key key,
      this.progressValue,
      this.left,
      this.top,
      this.width,
      this.height, this.brightness})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArcProgressWidgetState();
}

class _ArcProgressWidgetState extends AnimatedState<ArcProgressWidget> {
  double _fraction = 0.0;
  bool _started = false;
  double previousValue;

  @override
  void initState() {
    super.initState();
  }

  void _startAnimation() {
    if (!_started && previousValue != widget.progressValue) {
      _fraction = 0.0;
      if (previousValue == null || widget.progressValue < previousValue) {
        previousValue = widget.progressValue;
      }
      if (widget.progressValue != 0) {
        animateTween(duration: 500);
        _started = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _startAnimation();
    //print("width: " + context.size.width.toString());
    //print("Width: "+ MediaQuery.of(context).size.width.toString());
    return Container(

        key: Key("sun_path_widget_sized_box"),
        child: CustomPaint(
          key: Key("sun_path_widget_custom_paint"),
          painter: _ArcProgressPainter(widget.progressValue, previousValue,
              _fraction, widget.left, widget.top, widget.width, widget.height, widget.brightness),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onAnimatedValue(double value) {
    setState(() {
      _fraction = value;
    });
  }

  @override
  void onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      previousValue = widget.progressValue;
      clear();
      _started = false;
    }
  }
}

class _ArcProgressPainter extends CustomPainter {
  final double fraction;
  final double pi = 3.14159265359;
  final int dayAsMs = 86400000;
  final double progressValue;
  final double previousValue;
  final double left;
  final double top;
  final double width;
  final double height;
  final Brightness brightness;
  final double paintSize = 5;

  _ArcProgressPainter(this.progressValue, this.previousValue, this.fraction,
      this.left, this.top, this.width, this.height, this.brightness);

  @override
  void paint(Canvas canvas, Size size) {
    //Offset offset = Offset(left,top);
    //print("Offset is: " + offset.toString());

    Offset offset = Offset(width,width);
    Rect rect = Rect.fromCircle(center: offset, radius: width - paintSize/2);
    //Rect rect = Rect.fromLTWH(left, top, width, height);
    Paint arcPaint2 = _getArcPaint2();
    canvas.drawArc(
        rect, -0.5 * pi, getCurrentValue() * 2 * pi, false, arcPaint2);
  }

  double getCurrentValue() {
    return previousValue / 100 +
        (progressValue / 100 - previousValue / 100) * fraction;
  }

  @override
  bool shouldRepaint(_ArcProgressPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }


  Paint _getArcPaint2() {
    //print("Brightness: " + brightness.toString());
    Paint paint = Paint();
    if (brightness == Brightness.light) {
      paint..color = Colors.black87;
    } else {
      paint..color = Colors.white70;
    }
    paint..strokeWidth = paintSize;
    paint..style = PaintingStyle.stroke;
    return paint;
  }
}
