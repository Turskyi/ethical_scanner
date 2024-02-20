import 'package:flutter/material.dart';

class MaterialColors {
  MaterialColors();

  static const MaterialColor primarySwatch = MaterialColor(
    0xFF000C40,
    <int, Color>{
      50: Color.fromRGBO(0, 12, 64, .1),
      100: Color.fromRGBO(0, 12, 64, .2),
      200: Color.fromRGBO(0, 12, 64, .3),
      300: Color.fromRGBO(0, 12, 64, .4),
      400: Color.fromRGBO(0, 12, 64, .5),
      500: Color.fromRGBO(0, 12, 64, .6),
      600: Color.fromRGBO(0, 12, 64, .7),
      700: Color.fromRGBO(0, 12, 64, .8),
      800: Color.fromRGBO(0, 12, 64, .9),
      900: Color.fromRGBO(0, 12, 64, 1),
    },
  );

  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = <int, Color>{
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }

  final MaterialColor cetaceanBlue = const MaterialColor(
    0xFF000C40,
    <int, Color>{
      50: Color.fromRGBO(0, 12, 64, .1),
      100: Color.fromRGBO(0, 12, 64, .2),
      200: Color.fromRGBO(0, 12, 64, .3),
      300: Color.fromRGBO(0, 12, 64, .4),
      400: Color.fromRGBO(0, 12, 64, .5),
      500: Color.fromRGBO(0, 12, 64, .6),
      600: Color.fromRGBO(0, 12, 64, .7),
      700: Color.fromRGBO(0, 12, 64, .8),
      800: Color.fromRGBO(0, 12, 64, .9),
      900: Color.fromRGBO(0, 12, 64, 1),
    },
  );

  final MaterialColor antiFlashWhite = const MaterialColor(
    0xFFF0F2F0,
    <int, Color>{
      50: Color(0xFFF0F2F0),
      100: Color(0xFFE0ECE9),
      200: Color(0xFFC1D9D5),
      300: Color(0xFFA2C6C1),
      400: Color(0xFF83B3AD),
      500: Color(0xFF64A0A9),
      600: Color(0xFF558F99),
      700: Color(0xFF497F8B),
      800: Color(0xFF3D6F7D),
      900: Color(0xFF2F5E6E),
    },
  );

  final MaterialColor columbiaBlue = getMaterialColor(const Color(0xFFC4E0E5));
  final MaterialColor verdigris = getMaterialColor(const Color(0xFF4CA1AF));

// Red color
  final MaterialColor redMaterialColor = const MaterialColor(
    0xFFFF0000,
    <int, Color>{
      50: Color(0xFFFFE6E6),
      100: Color(0xFFFFCCCC),
      200: Color(0xFFFFB3B3),
      300: Color(0xFFFF9999),
      400: Color(0xFFFF8080),
      500: Color(0xFFFF6666),
      600: Color(0xFFFF4D4D),
      700: Color(0xFFFF3333),
      800: Color(0xFFFF1A1A),
      900: Color(0xFFFF0000),
    },
  );

// Blue-green color
  final MaterialColor blueGreenMaterialColor = const MaterialColor(
    0xFF00FFBF,
    <int, Color>{
      50: Color(0xFFE6FFF2),
      100: Color(0xFFCCFFE6),
      200: Color(0xFFB3FFD9),
      300: Color(0xFF99FFCC),
      400: Color(0xFF80FFBF),
      500: Color(0xFF66FFB3),
      600: Color(0xFF4DFFA6),
      700: Color(0xFF33FF99),
      800: Color(0xFF1AFF8C),
      900: Color(0xFF00FF80),
    },
  );

  final MaterialColor yellowMaterialColor = const MaterialColor(
    0xFFFFEB3B,
    <int, Color>{
      50: Color(0xFFFFFDE7),
      100: Color(0xFFFFF9C4),
      200: Color(0xFFFFF59D),
      300: Color(0xFFFFF176),
      400: Color(0xFFFFEE58),
      500: Color(0xFFFFEB3B),
      600: Color(0xFFFDD835),
      700: Color(0xFFFBC02D),
      800: Color(0xFFF9A825),
      900: Color(0xFFF57F17),
    },
  );

  final MaterialColor pinkMaterialColor = const MaterialColor(
    0xFFFF4081,
    <int, Color>{
      50: Color(0xFFFFF1F3),
      100: Color(0xFFFFE0E9),
      200: Color(0xFFFFB8D3),
      300: Color(0xFFFF8AC1),
      400: Color(0xFFFF68AE),
      500: Color(0xFFFF4081),
      600: Color(0xFFF50057),
      700: Color(0xFFF50057),
      800: Color(0xFFF50057),
      900: Color(0xFFF50057),
    },
  );

  final MaterialColor cyanMaterialColor = const MaterialColor(
    0xFF00BCD4,
    <int, Color>{
      50: Color(0xFFE0F7FA),
      100: Color(0xFFB2EBF2),
      200: Color(0xFF80DEEA),
      300: Color(0xFF4DD0E1),
      400: Color(0xFF26C6DA),
      500: Color(0xFF00BCD4),
      600: Color(0xFF00ACC1),
      700: Color(0xFF0097A7),
      800: Color(0xFF00838F),
      900: Color(0xFF006064),
    },
  );

  final MaterialColor purpleMaterialColor = const MaterialColor(
    0xFF6A1B9A,
    <int, Color>{
      50: Color(0xFFF3E5F5),
      100: Color(0xFFE1BEE7),
      200: Color(0xFFCE93D8),
      300: Color(0xFFBA68C8),
      400: Color(0xFFAB47BC),
      500: Color(0xFF9C27B0),
      600: Color(0xFF8E24AA),
      700: Color(0xFF7B1FA2),
      800: Color(0xFF6A1B9A),
      900: Color(0xFF4A148C),
    },
  );

  final MaterialColor orangeMaterialColor = const MaterialColor(
    0xFFF57C00,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(0xFFFF9800),
      600: Color(0xFFFB8C00),
      700: Color(0xFFF57C00),
      800: Color(0xFFEF6C00),
      900: Color(0xFFE65100),
    },
  );

  final MaterialColor greenMaterialColor = const MaterialColor(
    0xFF388E3C,
    <int, Color>{
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(0xFF4CAF50),
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );

  final MaterialColor grayMaterialColor = const MaterialColor(
    0xFF717171,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFE8E8E8),
      200: Color(0xFFD5D5D5),
      300: Color(0xFFC3C3C3),
      400: Color(0xFFB7B7B7),
      500: Color(0xFF717171),
      600: Color(0xFF6B6B6B),
      700: Color(0xFF616161),
      800: Color(0xFF575757),
      900: Color(0xFF414141),
    },
  );
}
