import 'package:flutter/material.dart';
import 'package:interface_adapters/src/ui/res/color/app_colors.dart';

class Gradients {
  Gradients();
  final LinearGradient pinkSunriseGradientBackground = LinearGradient(
    colors: <Color>[
      Colors.orange.shade200,
      Colors.pink.shade200,
    ],
    // Set the begin and end points
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  final LinearGradient unauthorizedConstructionGradient = const LinearGradient(
    colors: <Color>[
      AppColors.cetaceanBlue,
      AppColors.antiFlashWhite,
    ],
    // Set the stops
    stops: <double>[0.0, 1.0],
    // Set the begin and end points
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  final LinearGradient violetTwilightGradient = LinearGradient(
    colors: <Color>[
      Colors.purple.shade300,
      Colors.deepPurple.shade400,
    ],
  );

  final LinearGradient freshLimeGradient = LinearGradient(
    colors: <Color>[
      Colors.lightGreen.shade300,
      Colors.green.shade400,
    ],
  );

  // Abstract Love Gradient
  final LinearGradient abstractLoveGradient = const LinearGradient(
    colors: <Color>[
      Color(0xFFEE0979),
      Color(0xFFFF6A00),
    ],
    // Set the stops
    stops: <double>[0.0, 1.0],
    // Set the begin and end points
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

// Empty Words Gradient
  final LinearGradient emptyWordsGradient = const LinearGradient(
    colors: <Color>[
      Color(0xFFCFDEF3),
      Color(0xFFE0EAFC),
    ],
    // Set the stops
    stops: <double>[0.0, 1.0],
    // Set the begin and end points
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

// Marvel Character Gradient
  final LinearGradient marvelCharacterGradient = const LinearGradient(
    colors: <Color>[
      Color(0xFFC4E0E5),
      Color(0xFF4CA1AF),
    ],
    // Set the stops
    stops: <double>[0.0, 1.0],
    // Set the begin and end points
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
