import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interface_adapters/src/ui/models/maple_leaf.dart';
import 'package:interface_adapters/src/ui/modules/home/view/painters/maple_leaf_painter.dart';

class MapleLeafAnimation extends StatefulWidget {
  const MapleLeafAnimation({super.key});

  @override
  State<MapleLeafAnimation> createState() => _MapleLeafAnimationState();
}

class _MapleLeafAnimationState extends State<MapleLeafAnimation>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  final int _leafCount = 25;
  final double _minSize = 20.0;
  final double _maxSize = 40.0;
  final double _maxFallSpeed = 2.0;
  final double _maxRotationSpeed = 0.02;

  List<MapleLeaf> _leaves = <MapleLeaf>[];
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size size = MediaQuery.sizeOf(context);
      _leaves = List<MapleLeaf>.generate(_leafCount, (_) {
        return MapleLeaf(
          offset: Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          size: _random.nextDouble() * (_maxSize - _minSize) + _minSize,
          rotationAngle: _random.nextDouble() * pi * 2,
          rotationSpeed: (_random.nextDouble() - 0.5) * _maxRotationSpeed,
          fallSpeed: _random.nextDouble() * _maxFallSpeed + 0.5,
        );
      });

      _ticker = Ticker(_onTick)..start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: MapleLeafPainter(_leaves));
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final Size size = MediaQuery.sizeOf(context);

    setState(() {
      _leaves = _leaves.map((MapleLeaf leaf) {
        Offset newOffset = Offset(
          (leaf.offset.dx + sin(elapsed.inMilliseconds / 500) * 0.5) %
              size.width,
          (leaf.offset.dy + leaf.fallSpeed) % size.height,
        );

        return leaf.copyWith(
          offset: newOffset,
          rotationAngle: leaf.rotationAngle + leaf.rotationSpeed,
        );
      }).toList();
    });
  }
}