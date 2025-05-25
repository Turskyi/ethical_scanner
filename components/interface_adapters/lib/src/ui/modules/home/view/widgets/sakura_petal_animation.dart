import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interface_adapters/src/ui/models/sakura_petal.dart';
import 'package:interface_adapters/src/ui/modules/home/view/sakura_painter.dart';

class SakuraPetalAnimation extends StatefulWidget {
  const SakuraPetalAnimation({super.key});

  @override
  State<SakuraPetalAnimation> createState() => _SakuraPetalAnimationState();
}

class _SakuraPetalAnimationState extends State<SakuraPetalAnimation>
    with SingleTickerProviderStateMixin {
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
          size: _random.nextDouble() * 16 + 16,
          rotationAngle: _random.nextDouble() * 2 * pi,
          rotationSpeed: _random.nextDouble() * 0.01,
        );
      });

      _ticker = Ticker(_onTick)..start();
    });
  }

  void _onTick(Duration _) {
    setState(() {
      final Size screenSize = MediaQuery.sizeOf(context);
      _petals = _petals.map((SakuraPetal petal) {
        return petal.copyWith(
          offset: Offset(
            petal.offset.dx + sin(petal.rotationAngle) * 0.2,
            (petal.offset.dy + _fallSpeed) % screenSize.height,
          ),
          rotationAngle: petal.rotationAngle + petal.rotationSpeed,
        );
      }).toList();
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
}
