import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:smart_clock/widget/smart_clock.dart';

void main() => runApp(ClockCustomizer((ClockModel model) => SmartClock(
      clockModel: model,
    )));
