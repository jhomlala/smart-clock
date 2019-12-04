import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'animated_state.dart';

///Widget which visualises progress as a ring. Whole ring is equal to 100% progress.
///Widget (circle) is drawn in a rectangle. Progress value is animated.
class ArcProgressWidget extends StatefulWidget {
  ///Progress value as percent
  final double progressValue;

  ///Widget rectangle width. This parameter determines size of the ring.
  final double boxWidth;

  ///Current brightness, used to determine color of the ring
  final Brightness brightness;

  /// Time of animation once value changes
  final int animationTime;

  /// Ring paint size
  final double strokeWidth;

  ArcProgressWidget(
      {Key key,
      this.progressValue,
      this.boxWidth,
      this.brightness,
      this.animationTime,
      this.strokeWidth})
      : assert(progressValue != null && progressValue >= 0 && progressValue <= 100,
            "Progress value must be not null and must be between 0 and 100"),
        assert(boxWidth != null && boxWidth > 0, "Box width must be not null and greater than 0"),
        assert(animationTime != null && animationTime > 0, "Animation time must be not null and greater than 0"),
        assert(strokeWidth != null && strokeWidth > 0, "Stroke width must be not null and greater than 0"),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ArcProgressWidgetState();
}

class _ArcProgressWidgetState extends AnimatedState<ArcProgressWidget> {
  ///Fraction parameter describes state of current animation. This value changes
  ///from 0 to 1 and is used to determine current ring position in animation
  double _fraction = 0.0;

  ///Is animation started
  bool _animationStarted = false;

  ///Previous value of ring, used to create delta animation
  double previousValue;

  @override
  void initState() {
    super.initState();
  }

  ///Start animation on rebuild. Once animation is started, it will be blocked until
  ///animation finishes.
  void _startAnimation() {
    if (!_animationStarted && previousValue != widget.progressValue) {
      _fraction = 0.0;
      if (previousValue == null || widget.progressValue < previousValue) {
        previousValue = widget.progressValue;
      }
      if (widget.progressValue != 0) {
        startAnimation(duration: widget.animationTime);
        _animationStarted = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _startAnimation();
    return Container(
        child: CustomPaint(
      painter: _ArcProgressPainter(widget.progressValue, previousValue,
          _fraction, widget.boxWidth, widget.brightness, widget.strokeWidth),
    ));
  }

  /// On animation value changes (this means we update fraction value and call set state, which will
  /// update widget).
  @override
  void onAnimatedValue(double value) {
    setState(() {
      _fraction = value;
    });
  }

  ///Listen for animation status change. Used to determine when animation finishes and unblock next animation.
  @override
  void onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      previousValue = widget.progressValue;
      clear();
      _animationStarted = false;
    }
  }
}

///Inner class which paints rings based on provided values.
class _ArcProgressPainter extends CustomPainter {
  /// Animation progress value (between 0 and 1)
  final double fraction;

  /// Next ring progress value (between 0 and 100)
  final double progressValue;

  /// Previous ring progress value (between 0 and 100, and lower than current progress value)
  final double previousProgressValue;

  ///Ring rectangle box size
  final double boxWidth;

  /// Application  brightness for light/dark theme
  final Brightness brightness;

  /// Stroke size for ring paint
  final double strokeWidth;

  _ArcProgressPainter(this.progressValue, this.previousProgressValue,
      this.fraction, this.boxWidth, this.brightness, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Offset offset = Offset(boxWidth, boxWidth);
    Rect rect =
        Rect.fromCircle(center: offset, radius: boxWidth - strokeWidth / 2);
    Paint arcPaint = _getArcPaint();
    canvas.drawArc(
        rect, -0.5 * pi, _getCurrentProgressValue() * 2 * pi, false, arcPaint);
  }


  ///Calculate progress based on previous and next progress value and fraction
  double _getCurrentProgressValue() {
    return previousProgressValue / 100 +
        (progressValue / 100 - previousProgressValue / 100) * fraction;
  }

  ///We should repaint widget if last fraction doesn't equals new fraction
  @override
  bool shouldRepaint(_ArcProgressPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }


  ///Create arc paint used for painting ring
  Paint _getArcPaint() {
    Paint paint = Paint();
    if (brightness == Brightness.light) {
      paint..color = Colors.black87;
    } else {
      paint..color = Colors.white70;
    }
    paint..strokeWidth = strokeWidth;
    paint..style = PaintingStyle.stroke;
    return paint;
  }
}
