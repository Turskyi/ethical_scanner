import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interface_adapters/src/ui/res/color/app_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';

class Fab extends StatefulWidget {
  const Fab({
    super.key,
    this.bottomPadding = 140.0,
    required this.onPressed,
    required this.onClose,
    this.expandedBody = const SizedBox(),
  });

  final double bottomPadding;
  final VoidCallback onPressed;
  final VoidCallback onClose;
  final Widget expandedBody;

  @override
  State<Fab> createState() => _FabState();
}

class _FabState extends State<Fab> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Define the width and height of the widget.
  final double _size = 100.0;

  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier<bool>(false);

  double get _bottomPadding => _isExpandedNotifier.value ? 0 : 140;
  final ValueNotifier<bool> _isEnabledNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _initBreathAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: _bottomPadding),
      duration: const Duration(seconds: 1),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: 1.0 + (_animation.value * 0.2),
                child: Container(
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    gradient: Resources.of(
                      context,
                    ).gradients.pinkSunriseGradientBackground,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.pink.shade100,
                        blurRadius: 40.0, // blur radius
                        spreadRadius: 0.0, // spread radius
                        offset: const Offset(2, 8), // offset
                      ),
                    ],
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isEnabledNotifier,
                    builder: (_, bool isEnabled, __) {
                      return FloatingActionButton(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shape: const CircleBorder(),
                        onPressed: isEnabled ? _onPressed : null,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isExpandedNotifier,
            builder: (_, bool isExpanded, __) => Visibility(
              visible: isExpanded,
              child: widget.expandedBody,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isExpandedNotifier,
            builder: (_, bool isExpanded, __) => AnimatedPositioned(
              bottom: isExpanded ? 0 : 2,
              duration: const Duration(seconds: 1),
              child: ValueListenableBuilder<bool>(
                valueListenable: _isEnabledNotifier,
                builder: (BuildContext context, bool isEnabled, Widget? child) {
                  return IconButton(
                    onPressed: isEnabled ? _onPressed : null,
                    icon: Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color:
                            isExpanded ? Colors.white.withOpacity(0.3) : null,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder:
                            (Widget child, Animation<double> anim) =>
                                RotationTransition(
                          turns:
                              Tween<double>(begin: 0.75, end: 1).animate(anim),
                          child: FadeTransition(opacity: anim, child: child),
                        ),
                        child: isExpanded
                            ? const Icon(
                                Icons.close_rounded,
                                key: ValueKey<String>('icon1'),
                                color: AppColors.cetaceanBlue,
                              )
                            : const Icon(
                                Icons.barcode_reader,
                                key: ValueKey<String>('icon2'),
                                color: AppColors.cetaceanBlue,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _isEnabledNotifier.dispose();
    super.dispose();
  }

  void _initBreathAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  void _onPressed() {
    HapticFeedback.vibrate();
    if (_isExpandedNotifier.value) {
      _animationController.reverse().whenComplete(() {
        _isExpandedNotifier.value = !_isExpandedNotifier.value;
        // It's necessary to use `setState` to trigger a rebuild of the widget
        // and update the UI, because the `_onPressed` method involves changing
        // the internal state of the widget (_isExpandedNotifier.value and
        // _animationController). Using `setState` ensures that these changes
        // are reflected in the UI in a way that's consistent with the Flutter
        // framework's rendering pipeline.
        setState(() => _initBreathAnimation());
        widget.onClose.call();
      });
    } else {
      _isEnabledNotifier.value = _isExpandedNotifier.value;
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 360),
      );
      _animation = Tween<double>(begin: 0, end: 84).animate(
        _animationController,
      );
      _animationController.forward().whenComplete(() {
        _isExpandedNotifier.value = !_isExpandedNotifier.value;
        widget.onPressed.call();
        _isEnabledNotifier.value = _isExpandedNotifier.value;
      });
    }
  }
}
