import 'dart:math';

import 'package:flutter/material.dart';

class ScanPainter extends CustomPainter {
  const ScanPainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    // Define meaningful names for numbers
    const double strokeWidthOuterRect = 4.0;
    const double strokeWidthInnerElements = 2.0;
    const double radiusCircle = 10.0;
    const double innerCircleRadius = 8.0;
    const double fullCircle = 2 * pi;
    const double half = 0.5;

    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidthOuterRect;
    canvas.drawRect(Offset.zero & size, paint);
    paint.color = Colors.green;
    paint.strokeWidth = strokeWidthInnerElements;
    double angle = value * fullCircle;
    double centerX = size.width * half;
    double centerY = size.height * half;
    double x = size.width * half + cos(angle) * size.width * half;
    double y = size.height * half + sin(angle) * size.height * half;
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(x, y),
      paint,
    );
    canvas.drawCircle(Offset(x, y), radiusCircle, paint);
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), innerCircleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
