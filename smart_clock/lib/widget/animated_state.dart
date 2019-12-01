import 'package:flutter/widgets.dart';

///Base class for all widgets which has animations. It provides useful interface
///to create animation based on fraction value.
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
  Animation<double> _getTween(
      double start, double end, Animation animation) {
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
