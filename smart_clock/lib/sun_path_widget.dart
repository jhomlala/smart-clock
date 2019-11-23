import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'animated_state.dart';

class SunPathWidget extends StatefulWidget {
  final double progressValue;
  final double left;
  final double top;
  final double width;
  final double height;

  SunPathWidget(
      {Key key,
      this.progressValue,
      this.left,
      this.top,
      this.width,
      this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SunPathWidgetState();
}

class _SunPathWidgetState extends AnimatedState<SunPathWidget> {
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
      if (previousValue == null || widget.progressValue < previousValue){
        previousValue = widget.progressValue;
      }
      if (widget.progressValue != 0){
        animateTween(duration: 500);
        _started = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _startAnimation();
    print("PAINT: CURRENT: " + widget.progressValue.toString() + " previous: " + previousValue.toString());
    return SizedBox(
        key: Key("sun_path_widget_sized_box"),
        width: 300,
        height: 150,
        child: CustomPaint(
          key: Key("sun_path_widget_custom_paint"),
          painter: _SunPathPainter(widget.progressValue, previousValue,
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
    print("Animation status: " + status.toString());
    if (status == AnimationStatus.completed) {
      print("Completed " + widget.progressValue.toString());
      previousValue = widget.progressValue;
      clear();
      _started = false;
    }
  }
}

class _SunPathPainter extends CustomPainter {
  final double fraction;
  final double pi = 3.14159265359;
  final int dayAsMs = 86400000;
  final double progressValue;
  final double previousValue;
  final double left;
  final double top;
  final double width;
  final double height;

  _SunPathPainter(this.progressValue, this.previousValue, this.fraction,
      this.left, this.top, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    Paint arcPaint = _getArcPaint();
    Rect rect = Rect.fromLTWH(left, top, width, height);
    //canvas.drawCircle(Offset(150, 60), 250, arcPaint);
    print("CurrentValue: " + getCurrentValue().toString());
    Paint arcPaint2 = _getArcPaint2();
    canvas.drawArc(
        rect, -0.5 * pi, getCurrentValue() * 2 * pi, false, arcPaint2);
  }

  double getCurrentValue() {
    double result = 0;
    print("Progress value: " + progressValue.toString() + " previous value: " + previousValue.toString() + " fraction: " + fraction.toString());
    //if (previousValue != null){
      result = previousValue / 100 +
          (progressValue / 100 - previousValue / 100) * fraction;
    //}
    /*if (result < 0){
      result = 0;
    }*/
    //print("Drawing ARC:" + result.toString());

    return result;
  }

  @override
  bool shouldRepaint(_SunPathPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }

  Paint _getArcPaint() {
    Paint paint = Paint();
    paint..color = Colors.grey;
    paint..strokeWidth = 7;
    paint..style = PaintingStyle.stroke;
    return paint;
  }

  Paint _getArcPaint2() {
    Paint paint = Paint();
    paint..color = Colors.white70;
    paint..strokeWidth = 7;
    paint..style = PaintingStyle.stroke;
    return paint;
  }

  Paint _getArcPaint3() {
    Paint paint = Paint();
    paint..color = Colors.white;
    paint..strokeWidth = 7;
    paint..style = PaintingStyle.stroke;
    return paint;
  }

  Paint _getCirclePaint() {
    Paint circlePaint = Paint();
    int mode = 0;
    if (mode == 0) {
      circlePaint..color = Colors.yellow;
    } else {
      circlePaint..color = Colors.white;
    }
    return circlePaint;
  }

/*Offset _getPosition(fraction) {
    int now = DateTimeHelper.getCurrentTime();
    int mode = WeatherHelper.getDayModeFromSunriseSunset(sunrise, sunset);
    double difference = 0;
    if (mode == 0) {
      difference = (now - sunrise) / (sunset - sunrise);
    } else if (mode == 1) {
      DateTime nextSunrise =
      DateTime.fromMillisecondsSinceEpoch(sunrise + dayAsMs);
      difference =
          (now - sunset) / (nextSunrise.millisecondsSinceEpoch - sunset);
    } else if (mode == -1) {
      DateTime previousSunset =
      DateTime.fromMillisecondsSinceEpoch(sunset - dayAsMs);
      difference = 1 -
          ((sunrise - now) / (sunrise - previousSunset.millisecondsSinceEpoch));
    }

    var x = 150 * cos((1 + difference * fraction) * pi) + 150;
    var y = 145 * sin((1 + difference * fraction) * pi) + 150;
    return Offset(x, y);
  }*/
}
