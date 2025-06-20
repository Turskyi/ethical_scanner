import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:interface_adapters/src/ui/models/snowflake.dart';
import 'package:interface_adapters/src/ui/modules/home/view/painters/snow_painter.dart';

class SnowAnimation extends StatefulWidget {
  const SnowAnimation({super.key});

  @override
  State<SnowAnimation> createState() => _SnowAnimationState();
}

class _SnowAnimationState extends State<SnowAnimation>
    with SingleTickerProviderStateMixin {
  final double _snowflakeSizeMultiplier = 30.0;
  final double _snowflakeSizeConstant = 5.0;
  final double _rotationSpeed = 0.02;
  final int _initialBatchSizeOfSnowflakes = 50;
  final double _fallSpeed = 1.0;

  /// Constants for fallback values
  final double _fallbackScreenWidth = 400;
  final double _fallbackScreenHeight = 800;
  final Random _random = Random();
  List<Snowflake> _snowflakes = <Snowflake>[];
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initializeSnowflakesAsync().then(_startSnowfallAnimation);
  }

  @override
  Ticker createTicker(void Function(Duration) onTick) =>
      Ticker(onTick)..start();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: SnowPainter(_snowflakes));
  }

  @override
  void dispose() {
    _ticker?.dispose();
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @pragma('vm:never-inline')
  Future<List<Snowflake>> _initializeSnowflakesAsync() {
    return Future<List<Snowflake>>.delayed(
      Duration.zero,
      _generateSnowflakeList,
    );
  }

  @pragma('vm:never-inline')
  List<Snowflake> _generateSnowflakeList() {
    if (mounted) {
      return List<Snowflake>.generate(
        _initialBatchSizeOfSnowflakes,
        (int _) {
          return Snowflake(
            offset: _randomOffset(),
            size: _randomSize(),
            rotationAngle: _randomRotationAngle(),
          );
        },
      );
    } else {
      return <Snowflake>[];
    }
  }

  void _updateSnowflakes(Duration elapsed) {
    if (_snowflakes.isNotEmpty) {
      for (int i = 0; i < _snowflakes.length; i++) {
        _snowflakes[i] = _snowflakes[i].copyWith(
          offset: Offset(
            _snowflakes[i].offset.dx,
            (_snowflakes[i].offset.dy + _fallSpeed) %
                MediaQuery.sizeOf(context).height,
          ),
        );
      }
    }
  }

  double _randomSize() {
    return _random.nextDouble() * _snowflakeSizeMultiplier +
        _snowflakeSizeConstant;
  }

  double _randomRotationAngle() => _random.nextDouble() * _rotationSpeed;

  Offset _randomOffset() {
    if (mounted) {
      Size size = MediaQuery.sizeOf(context);
      return Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      );
    } else {
      return Offset(
        _random.nextDouble() * _fallbackScreenWidth,
        _random.nextDouble() * _fallbackScreenHeight,
      );
    }
  }

  FutureOr<Null> _startSnowfallAnimation(List<Snowflake> snowflakes) {
    if (mounted) {
      setState(() {
        _snowflakes = snowflakes;
        _ticker = createTicker(_updateSnowflakes);
      });
    }
  }
}
