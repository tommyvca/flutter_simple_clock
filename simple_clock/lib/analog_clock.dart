import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'clock_hand.dart';


class AnalogClock extends StatefulWidget {
  final String _hour;
  final String _minute;
  final String _second;
  final Map _colors;
  final radiansPerTick = radians(360 / 60);
  final radiansPerHour = radians(360 / 12);

  AnalogClock(
    this._hour,
    this._minute,
    this._second,
    this._colors,
  );

  @override
  AnalogClockState createState() => new AnalogClockState();
}

class AnalogClockState extends State<AnalogClock> {
  DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final double hour = double.parse(widget._hour);
    final double minute = double.parse(widget._minute);
    final double second = double.parse(widget._second);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.height * 0.9,
        child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  size: Size(double.infinity, double.infinity),
                  painter: ClockFace(
                    radianPerTicks: widget.radiansPerTick,
                    tickPaddings: 50.0,
                    tickLength: 30.0,
                    tickInterval: 5.0,
                    tickWidth: 8.0,
                    tickColor: widget._colors['tickColor'],
                  ),
                ),
                ClockHand(
                  handRadius: 0.02,
                  handLength: 1.2,
                  angleRadians: second * widget.radiansPerTick,
                  handColor: widget._colors['secondHand'],
                  shadowDistance: 5,
                  handOffset: 50,
                ),
                ClockHand(
                  handRadius: 0.05,
                  handLength: 0.65,
                  angleRadians: (hour + minute / 60) * widget.radiansPerHour,
                  handColor: widget._colors['hourHand'],
                  shadowDistance: 15,
                  handOffset: 0,
                ),
                ClockHand(
                  handRadius: 0.1,
                  handLength: 1,
                  angleRadians: minute * widget.radiansPerTick,
                  handColor: widget._colors['minuteHand'],
                  shadowDistance: 20,
                  handOffset: 0,
                ),
                CustomPaint(
                  size: Size(double.infinity, double.infinity),
                  painter: ClockCircle(colors: widget._colors),
                ),
              ],
            )),
      ),
    );
  }
}

class ClockCircle extends CustomPainter {
  final colors;
  ClockCircle({this.colors});
  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final gradient = RadialGradient(
      center: const Alignment(0, 0.65),
      radius: 0.5,
      colors: [
        colors['clockCenterReflect'],
        colors['clockCenter'],
      ],
    );
    final circleRect = Rect.fromCenter(center: center, width: 30, height: 30);
    final paint = Paint()
      ..shader = gradient.createShader(circleRect);

    Path path = Path();

    path.addOval(circleRect);
    canvas.drawShadow(path, Colors.grey[800], 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ClockCircle oldDelegate) {
    return oldDelegate.colors['clockCenter'] != colors['clockCenter'];
  }
}

class ClockFace extends CustomPainter {
  final radianPerTicks;
  final tickPaddings;
  final tickLength;
  final tickWidth;
  final tickInterval;
  final tickColor;

  ClockFace({
    this.radianPerTicks,
    this.tickPaddings,
    this.tickLength,
    this.tickWidth,
    this.tickInterval,
    this.tickColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final angle = radianPerTicks;
    final radius = size.width / 2;
    final paint = Paint()
      ..color = tickColor
      ..strokeWidth = tickWidth;

    for (var i = 0; i < 60; i++) {
      if (i % tickInterval == 0) {
        var position1 = center +
            Offset(math.cos(angle * i), math.sin(angle * i)) *
                (radius - tickPaddings);
        var position2 = center +
            Offset(math.cos(angle * i), math.sin(angle * i)) *
                (radius - tickPaddings - tickLength);
        canvas.drawLine(position1, position2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ClockFace oldDelegate) {
    return false;
  }
}
