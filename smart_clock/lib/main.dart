import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:smart_clock/smart_clock.dart';

void main() =>  runApp(ClockCustomizer((ClockModel model) => SmartClock(clockModel: model,)));

class MyApp extends StatelessWidget {

  final ClockModel clockModel;

  const MyApp({Key key, this.clockModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: SmartClock(clockModel: clockModel),)
    );
  }
}

