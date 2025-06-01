import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';

class InteractiveHomePrompt extends StatelessWidget {
  const InteractiveHomePrompt({
    required this.displayText,
    super.key,
  });

  final String displayText;

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    final MaterialColors colors = resources.colors;
    final Dimens dimens = resources.dimens;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: dimens.bodyBottomMargin),
      child: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          final double? primaryVelocity = details.primaryVelocity;
          if (primaryVelocity != null && primaryVelocity > 0) {
            context.read<HomePresenter>().add(const PrecipitationToggleEvent());
          }
        },
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: <Color>[
                colors.columbiaBlue,
                colors.verdigris,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: AnimatedSwitcher(
            duration: resources.durations.animatedSwitcher,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
            ) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Text(
              displayText,
              key: ValueKey<String>(displayText),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Theme.of(
                  context,
                ).textTheme.headlineLarge?.fontSize,
                fontWeight: FontWeight.bold,
                shadows: <Shadow>[
                  Shadow(
                    blurRadius: dimens.bodyBlurRadius,
                    color: Colors.black,
                    offset: Offset(
                      dimens.bodyTitleOffset,
                      dimens.bodyTitleOffset,
                    ),
                  ),
                ],
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
