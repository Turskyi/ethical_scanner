import 'package:flutter/material.dart';

class Snowflake {
  const Snowflake({
    required this.offset,
    required this.size,
    required this.rotationAngle,
  });

  final Offset offset;
  final double size;
  final double rotationAngle;

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
