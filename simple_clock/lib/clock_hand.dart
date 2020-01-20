import 'dart:math' as math;

import 'package:flutter/material.dart';


class ClockHand extends StatefulWidget {
  final double handRadius;
  final double handLength;
  final double angleRadians;
  final Color handColor;
  final double shadowDistance;
  final double handOffset;

  ClockHand({
    this.handRadius,
    this.handLength,
    this.angleRadians,
    this.handColor,
    this.shadowDistance,
    this.handOffset,
  });

  @override
  ClockHandState createState() => new ClockHandState();
}

class ClockHandState extends State<ClockHand> {
  DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: MyPainter(
          handRadius: widget.handRadius,
          handLength: widget.handLength,
          angleRadians: widget.angleRadians,
          handColor: widget.handColor,
          shadowDistance: widget.shadowDistance,
          handOffset: widget.handOffset,
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double handRadius;
  final double handLength;
  final double angleRadians;
  final Color handColor;
  final double shadowDistance;
  final double handOffset;

  const MyPainter({
    @required this.handRadius,
    @required this.handLength,
    @required this.angleRadians,
    @required this.handColor,
    @required this.shadowDistance,
    @required this.handOffset,
  })  : assert(handRadius != null),
        assert(handLength != null),
        assert(angleRadians != null),
        assert(handColor != null),
        assert(shadowDistance != null),
        assert(handOffset != null);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final path = Path();
    final handRadius1 = size.width * handRadius / 2;
    final handLength1 = size.width / 2 * handLength;

    final angle = angleRadians - math.pi / 2.0;
    final center = (Offset.zero & size).center - Offset(math.cos(angle), math.sin(angle)) * handOffset;

    final position1 =
        center + Offset(math.cos(angle), math.sin(angle)) * handLength1;
    final position2 =
        center + Offset(math.cos(angle-math.pi/2), math.sin(angle-math.pi/2)) * handRadius1;
    final position3 =
        center + Offset(math.cos(angle+math.pi/2), math.sin(angle+math.pi/2)) * handRadius1;
    paint
      ..style = PaintingStyle.fill
      ..color = handColor;
    path
      ..moveTo(position1.dx, position1.dy)
      ..lineTo(position2.dx, position2.dy)

      ..arcToPoint (position3, radius: Radius.circular(handRadius), clockwise: false);

    canvas.drawShadow(path, Colors.grey[900], shadowDistance, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return oldDelegate.handColor != handColor || 
    oldDelegate.angleRadians != angleRadians;
  }
}
