import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/models/butterfly.dart';

class ButterflyPainter extends CustomPainter {
  const ButterflyPainter(this.butterflies);

  final List<Butterfly> butterflies;

  @override
  void paint(Canvas canvas, Size size) {
    for (final Butterfly b in butterflies) {
      canvas.save();
      canvas.translate(b.offset.dx, b.offset.dy);
      canvas.rotate(b.rotationAngle);

      final TextPainter painter = TextPainter(
        text: const TextSpan(
          text: '🦋',
          style: TextStyle(fontSize: 32),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      painter.paint(
        canvas,
        Offset(-b.size / 2, -b.size / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
