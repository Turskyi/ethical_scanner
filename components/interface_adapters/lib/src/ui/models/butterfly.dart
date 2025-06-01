import 'dart:ui';

class Butterfly {
  const Butterfly({
    required this.offset,
    required this.size,
    required this.direction,
    required this.flapAngle,
    required this.speed,
    required this.rotationAngle,
  });

  final Offset offset;
  final double size;
  final double direction;
  final double flapAngle;
  final double speed;
  final double rotationAngle;

  Butterfly copyWith({
    Offset? offset,
    double? size,
    double? direction,
    double? flapAngle,
    double? speed,
    double? rotationAngle,
  }) {
    return Butterfly(
      offset: offset ?? this.offset,
      size: size ?? this.size,
      direction: direction ?? this.direction,
      flapAngle: flapAngle ?? this.flapAngle,
      speed: speed ?? this.speed,
      rotationAngle: rotationAngle ?? this.rotationAngle,
    );
  }
}
