import 'package:flutter/material.dart';

class Snowflake {
  Snowflake({
    required this.offset,
    required this.size,
    required this.rotationAngle,
  });

  final Offset offset;
  final double size;
  double rotationAngle;

  Snowflake copyWith({
    Offset? offset,
    double? size,
    double? rotationAngle,
  }) =>
      Snowflake(
        offset: offset ?? this.offset,
        size: size ?? this.size,
        rotationAngle: rotationAngle ?? this.rotationAngle,
      );
}
