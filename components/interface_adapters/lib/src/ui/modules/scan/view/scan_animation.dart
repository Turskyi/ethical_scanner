import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/modules/scan/view/scan_painter.dart';

class ScanAnimation extends StatefulWidget {
  const ScanAnimation({super.key});

  @override
  State<ScanAnimation> createState() => _ScanAnimationState();
}

class _ScanAnimationState extends State<ScanAnimation>
    with SingleTickerProviderStateMixin {
  // Define meaningful names for durations and sizes
  final Duration _animationDuration = const Duration(seconds: 2);
  final double _paintSize = 300.0;
  final double _transparentOpacityAnimation = 0.0;
  final double _opaqueOpacityAnimation = 1.0;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _animation = Tween<double>(
      begin: _transparentOpacityAnimation,
      end: _opaqueOpacityAnimation,
    ).animate(_controller)
      // Update the UI when the animation value changes to ensure
      // that the `CustomPaint` widget repaints with the new animation state.
      ..addListener(() => setState(() {}));
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: ScanPainter(_animation.value),
        size: Size(_paintSize, _paintSize),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
