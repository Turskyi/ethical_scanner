import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:interface_adapters/src/ui/models/snowflake.dart';
import 'package:interface_adapters/src/ui/modules/home/view/snow_painter.dart';

class SnowAnimation extends StatefulWidget {
  const SnowAnimation({super.key});

  @override
  State<SnowAnimation> createState() => _SnowAnimationState();
}

class _SnowAnimationState extends State<SnowAnimation>
    with SingleTickerProviderStateMixin {
  List<Snowflake> _snowflakes = <Snowflake>[];
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSnowflakesAsync().then(_startSnowfallAnimation);
    });
  }

  @override
  Ticker createTicker(void Function(Duration) onTick) {
    return Ticker(onTick)..start();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: SnowPainter(_snowflakes));
  }

  @override
  void dispose() {
    _ticker.dispose();
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<List<Snowflake>> _initializeSnowflakesAsync() =>
      Future<List<Snowflake>>.delayed(Duration.zero, _generateSnowflakeList);

  List<Snowflake> _generateSnowflakeList() => List<Snowflake>.generate(
        50,
        (_) => Snowflake(
          offset: _randomOffset(),
          size: _randomSize(),
          rotationAngle: _randomRotationAngle(),
        ),
      );

  void _updateSnowflakes(Duration elapsed) {
    if (_snowflakes.isNotEmpty) {
      for (int i = 0; i < _snowflakes.length; i++) {
        _snowflakes[i] = _snowflakes[i].copyWith(
          offset: Offset(
            _snowflakes[i].offset.dx,
            (_snowflakes[i].offset.dy + 1) % MediaQuery.of(context).size.height,
          ),
        );
      }
    }
  }

  double _randomSize() {
    return Random().nextDouble() * 30 +
        5; // Adjust the range (30 is the multiplier, 5 is the constant)
  }

  double _randomRotationAngle() {
    return Random().nextDouble() * 0.02; // Adjust the rotation speed here
  }

  Offset _randomOffset() {
    Size size = MediaQuery.sizeOf(context);
    return Offset(
      Random().nextDouble() * size.width,
      Random().nextDouble() * size.height,
    );
  }

  FutureOr<Null> _startSnowfallAnimation(List<Snowflake> snowflakes) {
    setState(() {
      _snowflakes = snowflakes;
      _ticker = createTicker(_updateSnowflakes);
    });
  }
}
