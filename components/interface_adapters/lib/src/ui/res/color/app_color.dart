import 'package:flutter/painting.dart';

enum AppColor {
  cetaceanBlue,
  antiFlashWhite,
}

extension AppColorExtension on AppColor {
  Color get color {
    switch (this) {
      case AppColor.cetaceanBlue:
        return const Color(0xFF000C40);
      case AppColor.antiFlashWhite:
        return const Color(0xFFF0F2F0);
    }
  }
}
