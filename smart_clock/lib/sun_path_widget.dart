import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'animated_state.dart';

class ArcProgressWidget extends StatefulWidget {
  final double progressValue;
  final double left;
  final double top;
  final double width;
  final double height;

  ArcProgressWidget(
      {Key key,
      this.progressValue,
      this.left,
      this.top,
      this.width,
      this.height})
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
    return SizedBox(
        key: Key("sun_path_widget_sized_box"),
        width: 300,
        height: 150,
        child: CustomPaint(
          key: Key("sun_path_widget_custom_paint"),
          painter: _ArcProgressPainter(widget.progressValue, previousValue,
              _fraction, widget.left, widget.top, widget.width, widget.height),
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

  _ArcProgressPainter(this.progressValue, this.previousValue, this.fraction,
      this.left, this.top, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(left, top, width, height);
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
    Paint paint = Paint();
    paint..color = Colors.white70;
    paint..strokeWidth = 7;
    paint..style = PaintingStyle.stroke;
    return paint;
  }
}
