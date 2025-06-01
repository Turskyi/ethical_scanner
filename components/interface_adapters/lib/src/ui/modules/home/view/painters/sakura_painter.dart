import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/models/sakura_petal.dart';

class SakuraPainter extends CustomPainter {
  const SakuraPainter(this.petals);

  final List<SakuraPetal> petals;

  static const double _halfDivisor = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    for (final SakuraPetal petal in petals) {
      canvas.save();
      canvas.translate(petal.offset.dx, petal.offset.dy);
      canvas.rotate(petal.rotationAngle);

      final double fontSize = petal.size;
      TextPainter(
        text: TextSpan(
          text: '🌸',
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(
          canvas,
          Offset(-fontSize / _halfDivisor, -fontSize / _halfDivisor),
        );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
