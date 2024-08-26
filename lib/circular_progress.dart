import 'dart:math';

import 'package:flutter/material.dart';

class DashedCircularProgressIndicator extends StatefulWidget {
  final double progress; // Initial progress value from 0.0 to 1.0
  final double strokeWidth;
  final Color filledColor;
  final Color unfilledColor;
  final Duration duration;

  DashedCircularProgressIndicator({
    Key? key,
    required this.progress,
    this.strokeWidth = 8.0,
    this.filledColor = Colors.blue,
    this.unfilledColor = Colors.grey,
    this.duration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  DashedCircularProgressIndicatorState createState() =>
      DashedCircularProgressIndicatorState();
}

class DashedCircularProgressIndicatorState
    extends State<DashedCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateProgress(double newProgress) {
    setState(() {
      _animation =
          Tween<double>(begin: _animation.value, end: newProgress).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(100, 100),
          painter: _DashedCircularProgressPainter(
            progress: _animation.value,
            strokeWidth: widget.strokeWidth,
            filledColor: widget.filledColor,
            unfilledColor: widget.unfilledColor,
          ),
        );
      },
    );
  }
}

class _DashedCircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color filledColor;
  final Color unfilledColor;

  _DashedCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.filledColor,
    required this.unfilledColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = (size.width - strokeWidth) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCircle(center: center, radius: radius);
    double angle = 2 * pi * progress;

    // Paint the unfilled portion (dashed)
    Paint unfilledPaint = Paint()
      ..color = unfilledColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double dashLength = 5;
    double gapLength = 5;
    double circumference = 2 * pi * radius;
    double dashCount = circumference / (dashLength + gapLength);

    for (int i = 0; i < dashCount; i++) {
      double startAngle = (i * (dashLength + gapLength)) / radius;
      double sweepAngle = dashLength / radius;
      if (startAngle > angle) {
        canvas.drawArc(
            rect, startAngle - pi / 2, sweepAngle, false, unfilledPaint);
      }
    }

    // Paint the filled portion (solid)
    Paint filledPaint = Paint()
      ..color = filledColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi / 2, angle, false, filledPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
