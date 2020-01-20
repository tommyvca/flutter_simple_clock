import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bg_circle.dart';
import 'digital_clock.dart';
import 'analog_clock.dart';

class SimpleClock extends StatefulWidget {
  const SimpleClock(this.model);

  final ClockModel model;

  @override
  _SimpleClockState createState() => _SimpleClockState();
}

class _SimpleClockState extends State<SimpleClock> {
  var _weatherCondition = '';
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(SimpleClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _weatherCondition = widget.model.weatherString;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map _lightTheme = {
      'text': Color(0xFF565656),
      'hourHand': Color(0xFF2D2D2D),
      'minuteHand': Color(0xFF3A3A3A),
      'secondHand': Color(0xFF565656),
      'clockCenter': Color(0xFFFFFFFF),
      'clockCenterReflect': Color(0xFFD5D5D5),
      'bgColor': Color(0xFFF3F3F3),
      'bgGradient': LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFD2D2D2),
            Color(0xFFFFFFFF),
          ],
          stops: [
            0.3,
            0.5,
          ]),
      'circleColor': Color(0xFFD5D5D5),
      'movingCircleColor': Color(0xFFD5D5D5),
      'cicrleShadow': Colors.white38,
      'tickColor': Color(0xFF565656),
    };

    final Map _darkTheme = {
      'text': Color(0xFFDDDDDD),
      'hourHand': Color(0xFFC6C6C6),
      'minuteHand': Color(0xFFDDDDDD),
      'secondHand': Color(0xFF686868),
      'clockCenter': Color(0xFF030303),
      'clockCenterReflect': Color(0xFF333333),
      'bgColor': Color(0xFF333333),
      'bgGradient': LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xFF141414),
          Color(0xFF333333),
        ],
        stops: [
          0.3,
          0.8,
        ],
      ),
      'circleColor': Color(0xFF030303),
      'movingCircleColor': Color(0xFF030303),
      'cicrleShadow': Colors.black38,
      'tickColor': Color(0xFFDDDDDD),
    };

    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final is24HourFormat = widget.model.is24HourFormat;
    final time = DateFormat(is24HourFormat ? 'HH:mm' : 'h:mm').format(_dateTime);
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'h').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);
    var amPmMarker;
    if (!is24HourFormat) {
      amPmMarker = DateFormat('a').format(_dateTime);
    } else {
      amPmMarker = '';
    }
    final date = DateFormat('E, MMM d').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 12;

    final defaultStyle = TextStyle(
      color: colors['text'],
      fontFamily: 'OpenSans',
      fontSize: fontSize,
      fontWeight: FontWeight.w300,
      height: 1,
      letterSpacing: 3,

    );

    final secondTextStyle = TextStyle(
      color: colors['text'],
      fontFamily: 'OpenSans',
      fontSize: fontSize / 4,
      fontWeight: FontWeight.w500,
      height: 1,
    );
    final weatherCondition = _weatherCondition;
    int rippleCount;
    
    if (weatherCondition == 'rainy' || weatherCondition == 'thunderstorm') {
      rippleCount = 1;
    } else {
      rippleCount = 0;
    }

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Container(
        key: ValueKey(colors['bgGradient']),
        decoration: BoxDecoration(
          gradient: colors['bgGradient'],
        ),
        child: Stack(
          children: <Widget>[
            new BackgroundCircle(
              colors: colors,
              circleThickness: 1,
              circleGap: 10,
              animationDuration: 60,
              waveCount: 75,
              movingCircleCount: rippleCount,
              movingCircleGap: 5,
            ),
            new DigitalClock(colors, defaultStyle, secondTextStyle, amPmMarker, time, date, weatherCondition),
            new AnalogClock(hour, minute, second, colors),
          ],
        ),
      ),
    );
  }
}