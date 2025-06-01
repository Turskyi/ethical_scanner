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
  static const double _initialDirectionForward = 1.0;
  static const double _initialDirectionBackward = -1.0;

  /// Base speed added to random speed.
  static const double _minBaseSpeed = 0.5;
  static const int _maxFlutterPhase = 240;

  /// For 2 * PI calculations.
  static const double _fullCircleMultiplier = 2.0;
  static const double _fullCycleRadians = _fullCircleMultiplier * pi;
  static const double _flapAngleIncrement = 0.05;
  static const double _swayMultiplier = 1.5;
  static const double _verticalDriftAngleFactor = 1.3;
  static const double _verticalDriftMagnitude = 1.2;

  /// 0.5% chance.
  static const double _reverseDirectionProbability = 0.005;
  static const double _flipYProbability = 0.005;

  /// Per-tick rotation change.
  static const double _rotationAngleIncrement = 0.01;
  static const double _blinkPhaseIncrement = 0.02;

  final Random _random = Random();
  final int _butterflyCount = 20;
  final double _minSize = 24.0;
  final double _maxSize = 48.0;
  final double _maxSpeed = 1.5;
  final double _maxRotation = pi * 2;

  List<Butterfly> _butterflies = <Butterfly>[];
  Ticker? _ticker;
  int _frameCount = 0;

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
          direction: _random.nextBool()
              ? _initialDirectionForward
              : _initialDirectionBackward,
          flapAngle: _random.nextDouble() * _maxRotation,
          speed: _random.nextDouble() * _maxSpeed + _minBaseSpeed,
          rotationAngle: _random.nextDouble() * _maxRotation,
          isUpsideDown: _random.nextBool(),
          flutterPhase: _random.nextInt(_maxFlutterPhase),
          blinkPhase: _random.nextDouble() * _fullCycleRadians,
        );
      });

      _ticker = Ticker(_onTick)..start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ButterflyPainter(_butterflies, _frameCount));
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final Size size = MediaQuery.sizeOf(context);
    _frameCount++;

    setState(() {
      _butterflies = _butterflies.map((Butterfly b) {
        final double newFlapAngle = b.flapAngle + _flapAngleIncrement;
        final double sway = sin(newFlapAngle) * _swayMultiplier;
        final double verticalDrift =
            sin(newFlapAngle * _verticalDriftAngleFactor) *
                _verticalDriftMagnitude;

        // Occasionally reverse direction (simulate flutter).
        final bool shouldReverse =
            _random.nextDouble() < _reverseDirectionProbability;
        final double newDirection = shouldReverse ? -b.direction : b.direction;

        Offset newOffset = Offset(
          (b.offset.dx + newDirection * b.speed + sway) % size.width,
          (b.offset.dy + verticalDrift) % size.height,
        );

        // Boundary checks (these `0`s are usually okay as they represent
        // edges).
        if (newOffset.dx < 0) newOffset = Offset(size.width, newOffset.dy);
        if (newOffset.dx > size.width) newOffset = Offset(0, newOffset.dy);
        if (newOffset.dy < 0) newOffset = Offset(newOffset.dx, size.height);
        // The number `0` here refers to the minimum coordinate (left/top edge)
        // and is generally not considered a "magic number" in the same way
        // arbitrary multipliers or probabilities are.

        final bool flipY = _random.nextDouble() < _flipYProbability
            ? !_random.nextBool()
            : b.isUpsideDown;

        return b.copyWith(
          offset: newOffset,
          flapAngle: newFlapAngle,
          rotationAngle: b.rotationAngle + _rotationAngleIncrement,
          direction: newDirection,
          isUpsideDown: flipY,
          blinkPhase:
              (b.blinkPhase + _blinkPhaseIncrement) % (_fullCycleRadians),
        );
      }).toList();
    });
  }
}
