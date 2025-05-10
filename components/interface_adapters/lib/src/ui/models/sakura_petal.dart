import 'dart:ui';

class SakuraPetal {
  const SakuraPetal({
    required this.offset,
    required this.size,
    required this.rotationAngle,
    required this.rotationSpeed,
  });

  final Offset offset;
  final double size;
  final double rotationAngle;
  final double rotationSpeed;

  SakuraPetal copyWith({
    Offset? offset,
    double? size,
    double? rotationAngle,
    double? rotationSpeed,
  }) {
    return SakuraPetal(
      offset: offset ?? this.offset,
      size: size ?? this.size,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      rotationSpeed: rotationSpeed ?? this.rotationSpeed,
    );
  }
}
