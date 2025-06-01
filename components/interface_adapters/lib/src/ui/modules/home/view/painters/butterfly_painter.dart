import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/models/butterfly.dart';

class ButterflyPainter extends CustomPainter {
  const ButterflyPainter(this.butterflies, this.frameCount);

  final List<Butterfly> butterflies;
  final int frameCount;

  static const int _flutterCycle = 60;

  /// Portion of the cycle the butterfly is visible.
  static const double _flutterOnDurationPortion = 0.5;

  /// Scale factor for Y-axis when upside down.
  static const double _scaleFactorFlip = -1.0;

  /// Scale factor for Y-axis when normal.
  static const double _scaleFactorNormal = 1.0;

  /// Divisor to center the symbol on its offset.
  static const double _centeringDivisor = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    for (final Butterfly b in butterflies) {
      final bool show = ((frameCount + b.flutterPhase) % _flutterCycle) <
          (_flutterCycle - _flutterOnDurationPortion);
      if (!show) continue;

      canvas.save();
      canvas.translate(b.offset.dx, b.offset.dy);
      canvas.rotate(b.rotationAngle);
      // Apply vertical flip if the butterfly is upside down.
      final double scaleY =
          b.isUpsideDown ? _scaleFactorFlip : _scaleFactorNormal;
      canvas.scale(scaleY);

      final TextPainter painter = TextPainter(
        text: TextSpan(
          text: '🦋',
          style: TextStyle(fontSize: b.size),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Paint the butterfly centered on its current translated & rotated origin
      painter.paint(
        canvas,
        Offset(-b.size / _centeringDivisor, -b.size / _centeringDivisor),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
