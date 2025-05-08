import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/interface_adapters.dart';
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

  /// Define the width and height of the widget.
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
    return BlocConsumer<HomePresenter, HomeViewModel>(
      listener: _viewModelListener,
      builder: (_, HomeViewModel viewModel) {
        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: _bottomPadding),
          duration: Duration(seconds: DurationSeconds.short.time),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext _, Widget? __) {
                  return Transform.scale(
                    scale: 1.0 + (_animation.value * 0.2),
                    child: Semantics(
                      label: translate('home.fab'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        width: _size,
                        height: _size,
                        decoration: _getBoxDecoration(viewModel),
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
                builder: (_, bool isExpanded, __) {
                  return AnimatedPositioned(
                    bottom: isExpanded ? 0 : 2,
                    duration: Duration(seconds: DurationSeconds.short.time),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isEnabledNotifier,
                      builder: (
                        BuildContext context,
                        bool isEnabled,
                        Widget? _,
                      ) {
                        final double iconSize = 78.0;
                        return IconButton(
                          onPressed: isEnabled ? _onPressed : null,
                          icon: Container(
                            width: iconSize,
                            height: iconSize,
                            decoration: BoxDecoration(
                              color: isExpanded
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : null,
                              shape: BoxShape.circle,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (
                                Widget child,
                                Animation<double> anim,
                              ) {
                                return RotationTransition(
                                  turns: Tween<double>(begin: 0.75, end: 1)
                                      .animate(anim),
                                  child: FadeTransition(
                                    opacity: anim,
                                    child: child,
                                  ),
                                );
                              },
                              child: isExpanded
                                  ? Icon(
                                      Icons.close_rounded,
                                      key: const ValueKey<IconData>(
                                        Icons.close_rounded,
                                      ),
                                      color: Resources.of(
                                        context,
                                      ).colors.cetaceanBlue,
                                    )
                                  : Icon(
                                      Icons.barcode_reader,
                                      key: const ValueKey<IconData>(
                                        Icons.barcode_reader,
                                      ),
                                      color: Resources.of(
                                        context,
                                      ).colors.cetaceanBlue,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _getBoxDecoration(HomeViewModel viewModel) {
    return BoxDecoration(
      gradient: viewModel is LoadedProductInfoState &&
              (viewModel.productInfo.isCompanyTerrorismSponsor ||
                  viewModel.productInfo.isFromRussia)
          ? const LinearGradient(
              colors: <Color>[
                Colors.pinkAccent,
                Colors.red,
              ],
              // Set the begin and end points
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          : viewModel is LoadedProductInfoState &&
                  (viewModel.productInfo.isVegan ||
                      viewModel.productInfo.isVegetarian)
              ? const LinearGradient(
                  colors: <Color>[
                    Colors.green,
                    Colors.lightGreen,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : Resources.of(
                  context,
                ).gradients.pinkSunriseGradientBackground,
      shape: BoxShape.circle,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.pink.shade100,
          blurRadius: 40.0,
          spreadRadius: 0.0,
          offset: const Offset(2, 8),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _isEnabledNotifier.dispose();
    super.dispose();
  }

  void _viewModelListener(BuildContext _, HomeViewModel viewModel) {
    if (_isExpandedNotifier.value && viewModel is ReadyToScanState) {
      _animationController.reverse().whenComplete(() {
        _isExpandedNotifier.value = !_isExpandedNotifier.value;
        // It's necessary to use `setState` to trigger a rebuild of the
        // widget and update the UI, because the `_onPressed` method
        // involves changing the internal state of the widget
        // (_isExpandedNotifier.value and _animationController). Using
        // `setState` ensures that these changes are reflected in the UI in
        // a way that's consistent with the Flutter framework's rendering
        // pipeline.
        setState(() => _initBreathAnimation());
      });
    }
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
      widget.onClose.call();
    } else {
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
