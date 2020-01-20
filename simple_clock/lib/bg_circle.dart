import 'package:flutter/material.dart';


class BackgroundCircle extends StatefulWidget {
  final Map colors;
  final double circleThickness;
  final double circleGap;

  final int animationDuration;
  final int waveCount;

  final int movingCircleCount;
  final double movingCircleGap;

  BackgroundCircle({
    this.colors,
    this.circleThickness,
    this.circleGap,
    this.animationDuration,
    this.waveCount,
    this.movingCircleCount,
    this.movingCircleGap,
  });

  @override
  _BackgroundCircleState createState() => _BackgroundCircleState();
}

class _BackgroundCircleState extends State<BackgroundCircle>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation cicleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: widget.animationDuration),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );

    cicleAnimation = IntTween(
      begin: 0,
      end: widget.waveCount +
          widget.movingCircleCount * widget.movingCircleGap.toInt(),
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
          animationController.forward();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: CirclePainter(
          circleColor: widget.colors['circleColor'],
          movingCircleColor: widget.colors['movingCircleColor'],
          circleShadow: widget.colors['cicrleShadow'],
          circleThickness: widget.circleThickness,
          circleGap: widget.circleGap,
          waveCount: widget.waveCount,
          animationValue: cicleAnimation.value,
          movingCircleCount: widget.movingCircleCount,
          movingCircleGap: widget.movingCircleGap,
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final Color circleColor;
  final Color movingCircleColor;
  final Color circleShadow;
  final double circleThickness;
  final double circleGap;
  final int animationValue;

  final int waveCount;

  final int movingCircleCount;
  final double movingCircleGap;

  CirclePainter({
    this.circleColor,
    this.movingCircleColor,
    this.circleShadow,
    this.circleThickness,
    this.circleGap,
    this.waveCount,
    this.animationValue,
    this.movingCircleCount,
    this.movingCircleGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;

    final paint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleThickness;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint2 = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (var i = 0; i < waveCount; i++) {
      for (var a = 0; a < movingCircleCount; a++) {
        if (i == animationValue - a * movingCircleGap) {
          canvas.drawCircle(center, (circleGap * i) - movingCircleGap, paint2);
          canvas.drawCircle(center, (circleGap * i) + movingCircleGap, paint2);
        } else {
          final circleRect =
              Rect.fromCircle(center: center, radius: circleGap * i);
          final circleRect2 =
              Rect.fromCircle(center: center, radius: circleGap * i + 3);
          Path path = Path();
          Path path2 = Path();
          path.addOval(circleRect);
          path2.addOval(circleRect2);

          canvas.drawPath(path, paint);
        }
      }
      if (movingCircleCount == 0) {
        final circleRect =
            Rect.fromCircle(center: center, radius: circleGap * i);
        final circleRect2 =
            Rect.fromCircle(center: center, radius: circleGap * i + 3);
        Path path = Path();
        Path path2 = Path();
        path.addOval(circleRect);
        path2.addOval(circleRect2);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return true;
  }
}
