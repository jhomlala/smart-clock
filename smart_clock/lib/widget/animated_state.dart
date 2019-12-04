import 'package:flutter/widgets.dart';

///Base class for all stateful widgets which has animations. It provides useful
///interface to create animation between two values in given time and curve. It
///may be overkill for this project, but if we count this as educational then
///it's pretty nice to use it here and next future projects :). Can be easily
///incorporated with RxDart.
abstract class AnimatedState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin {
  AnimationController _controller;

  /// On animation value changes (fraction)
  void onAnimatedValue(double value);

  /// On animation status changed i.e completed
  void onAnimationStatusChanged(AnimationStatus status);

  ///Start animation between start and end value in given duration and curve.
  startAnimation(
      {double start = 0.0,
      double end = 1.0,
      int duration: 1000,
      Curve curve = Curves.linear}) {
    assert(start != null && start >= 0,
        "Start must be not null and must be greater or equals 0.0");
    assert(end != null && end >= 0,
        "End must be not null and must be greater or equals 0.0");
    assert(start < end, "End must be greater than start");
    assert(duration != null && duration > 0,
        "Duration must be not null and must be greater than 0");
    assert(curve != null, "Curve must be not null");
    _controller = _getAnimationController(this, duration);
    Animation animation = _getCurvedAnimation(_controller, curve);

    Animation<double> tweenAnimation = _getTween(start, end, animation);
    var valueListener = () {
      onAnimatedValue(tweenAnimation.value);
    };
    tweenAnimation.addListener(valueListener);
    _controller.addStatusListener(onAnimationStatusChanged);
    _controller.forward();
  }

  ///Create new animation controller
  AnimationController _getAnimationController(
      TickerProviderStateMixin object, int duration) {
    return AnimationController(
        duration: Duration(milliseconds: duration), vsync: object);
  }

  ///Create curved animation based on settings
  Animation _getCurvedAnimation(AnimationController controller, Curve curve) {
    return CurvedAnimation(parent: controller, curve: curve);
  }

  ///Create tween between start and end with given animation
  Animation<double> _getTween(double start, double end, Animation animation) {
    return Tween(begin: start, end: end).animate(animation);
  }

  ///Clear previous animation before starting next one
  void clear() {
    if (_controller != null) {
      _controller.dispose();
    }
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}
