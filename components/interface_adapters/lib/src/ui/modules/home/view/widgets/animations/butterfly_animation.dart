import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interface_adapters/src/ui/models/butterfly.dart';
import 'package:interface_adapters/src/ui/modules/home/view/painters/butterfly_painter.dart';

class ButterflyAnimation extends StatefulWidget {
  const ButterflyAnimation({super.key});

  @override
  State<ButterflyAnimation> createState() => _ButterflyAnimationState();
}

class _ButterflyAnimationState extends State<ButterflyAnimation>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  final int _butterflyCount = 20;
  final double _minSize = 24.0;
  final double _maxSize = 48.0;
  final double _maxSpeed = 1.5;
  final double _maxRotation = pi * 2;

  List<Butterfly> _butterflies = <Butterfly>[];
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size size = MediaQuery.sizeOf(context);
      _butterflies = List<Butterfly>.generate(_butterflyCount, (_) {
        return Butterfly(
          offset: Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          size: _random.nextDouble() * (_maxSize - _minSize) + _minSize,
          direction: _random.nextBool() ? 1.0 : -1.0,
          flapAngle: _random.nextDouble() * _maxRotation,
          speed: _random.nextDouble() * _maxSpeed + 0.5,
          rotationAngle: _random.nextDouble() * _maxRotation,
        );
      });

      _ticker = Ticker(_onTick)..start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ButterflyPainter(_butterflies));
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final Size size = MediaQuery.sizeOf(context);

    setState(() {
      _butterflies = _butterflies.map((Butterfly b) {
        final double newFlapAngle = b.flapAngle + 0.05;
        final double sway = sin(newFlapAngle) * 1.5;
        final double verticalDrift = sin(newFlapAngle * 1.3) * 1.2;

        // Occasionally reverse direction (simulate flutter).
        // 0.5% chance per frame.
        final bool shouldReverse = _random.nextDouble() < 0.005;
        final double newDirection = shouldReverse ? -b.direction : b.direction;

        Offset newOffset = Offset(
          (b.offset.dx + newDirection * b.speed + sway) % size.width,
          (b.offset.dy + verticalDrift) % size.height,
        );

        // Wrap around horizontally
        if (newOffset.dx < 0) newOffset = Offset(size.width, newOffset.dy);
        if (newOffset.dx > size.width) newOffset = Offset(0, newOffset.dy);
        if (newOffset.dy < 0) newOffset = Offset(newOffset.dx, size.height);

        return b.copyWith(
          offset: newOffset,
          flapAngle: newFlapAngle,
          rotationAngle: b.rotationAngle + 0.01,
          direction: newDirection,
        );
      }).toList();
    });
  }
}
