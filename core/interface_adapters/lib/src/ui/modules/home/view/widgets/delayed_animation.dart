import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interface_adapters/interface_adapters.dart';

class DelayedAnimation extends StatefulWidget {
  const DelayedAnimation({
    super.key,
    required this.delay,
    required this.child,
  });

  final int delay;
  final Widget child;

  @override
  State<DelayedAnimation> createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    final CurvedAnimation curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuint,
    );
    _animOffset = Tween<Offset>(
      begin: Offset(AnimationConstants.transparentOpacityAnimation.value, 0.35),
      end: Offset.zero,
    ).animate(curve);
    if (widget.delay == 0) {
      _controller.forward();
    } else {
      Future<void>.delayed(
        Duration(milliseconds: widget.delay),
        _startAnimationIfActive,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FutureOr<void> _startAnimationIfActive() {
    if (mounted) {
      _controller.forward();
    }
  }
}
