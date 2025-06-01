import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interface_adapters/src/ui/models/sakura_petal.dart';
import 'package:interface_adapters/src/ui/modules/home/view/painters/sakura_painter.dart';

class SakuraPetalAnimation extends StatefulWidget {
  const SakuraPetalAnimation({super.key});

  @override
  State<SakuraPetalAnimation> createState() => _SakuraPetalAnimationState();
}

class _SakuraPetalAnimationState extends State<SakuraPetalAnimation>
    with SingleTickerProviderStateMixin {
  static const double _minPetalSize = 16.0;

  /// Max size will be [_minPetalSize] + [_petalSizeVariation].
  static const double _petalSizeVariation = 16.0;

  /// For 2 * pi.
  static const double _maxRotationAngleMultiplier = 2.0;
  static const double _maxInitialRotationSpeed = 0.01;

  /// Sideways movement factor.
  static const double _swayFactor = 0.2;

  final Random _random = Random();
  final int _initialPetalCount = 30;
  final double _fallSpeed = 0.7;

  List<SakuraPetal> _petals = <SakuraPetal>[];
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size size = MediaQuery.sizeOf(context);
      _petals = List<SakuraPetal>.generate(_initialPetalCount, (_) {
        return SakuraPetal(
          offset: Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          size: _random.nextDouble() * _petalSizeVariation + _minPetalSize,
          rotationAngle:
              _random.nextDouble() * _maxRotationAngleMultiplier * pi,
          rotationSpeed: _random.nextDouble() * _maxInitialRotationSpeed,
        );
      });

      _ticker = Ticker(_onTick)..start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: SakuraPainter(_petals));
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _onTick(Duration _) {
    setState(() {
      final Size screenSize = MediaQuery.sizeOf(context);
      _petals = _petals.map((SakuraPetal petal) {
        return petal.copyWith(
          offset: Offset(
            petal.offset.dx + sin(petal.rotationAngle) * _swayFactor,
            (petal.offset.dy + _fallSpeed) % screenSize.height,
          ),
          rotationAngle: petal.rotationAngle + petal.rotationSpeed,
        );
      }).toList();
    });
  }
}
