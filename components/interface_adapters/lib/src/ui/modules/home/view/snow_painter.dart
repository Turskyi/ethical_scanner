import 'dart:math';

import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/models/snowflake.dart';

class SnowPainter extends CustomPainter {
  const SnowPainter(this.snowflakes);

  final List<Snowflake> snowflakes;

  /// Constant for maximum rotation speed
  static const double _maxRotationSpeed = 0.03;

  /// Constant for size adjustment factor
  static const double _sizeAdjustmentFactor = 2;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < snowflakes.length; i++) {
      canvas.save();
      canvas.translate(snowflakes[i].offset.dx, snowflakes[i].offset.dy);
      snowflakes[i] = _incrementRotationAngle(snowflakes[i]);

      // Draw the ac_unit icon without background
      final double rotationAngle = snowflakes[i].rotationAngle;
      canvas.rotate(rotationAngle);

      TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.ac_unit.codePoint),
          style: TextStyle(
            fontSize: snowflakes[i].size,
            fontFamily: Icons.ac_unit.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(
          canvas,
          Offset(
            -snowflakes[i].size / _sizeAdjustmentFactor,
            -snowflakes[i].size / _sizeAdjustmentFactor,
          ),
        );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double _randomRotationAngle() => Random().nextDouble() * _maxRotationSpeed;

  Snowflake _incrementRotationAngle(Snowflake snowflake) => snowflake.copyWith(
        rotationAngle: snowflake.rotationAngle + _randomRotationAngle(),
      );
}
