import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/models/maple_leaf.dart';

class MapleLeafPainter extends CustomPainter {
  const MapleLeafPainter(this.leaves);

  final List<MapleLeaf> leaves;

  @override
  void paint(Canvas canvas, Size size) {
    for (final MapleLeaf leaf in leaves) {
      canvas.save();
      canvas.translate(leaf.offset.dx, leaf.offset.dy);
      canvas.rotate(leaf.rotationAngle);

      final TextPainter painter = TextPainter(
        text: TextSpan(
          text: '🍁',
          style: TextStyle(fontSize: leaf.size),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      painter.paint(
        canvas,
        Offset(-leaf.size / 2, -leaf.size / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
