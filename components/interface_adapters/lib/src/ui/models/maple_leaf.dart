import 'dart:ui';

class MapleLeaf {
  const MapleLeaf({
    required this.offset,
    required this.size,
    required this.rotationAngle,
    required this.rotationSpeed,
    required this.fallSpeed,
  });

  final Offset offset;
  final double size;
  final double rotationAngle;
  final double rotationSpeed;
  final double fallSpeed;

  MapleLeaf copyWith({
    Offset? offset,
    double? size,
    double? rotationAngle,
    double? rotationSpeed,
    double? fallSpeed,
  }) {
    return MapleLeaf(
      offset: offset ?? this.offset,
      size: size ?? this.size,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      rotationSpeed: rotationSpeed ?? this.rotationSpeed,
      fallSpeed: fallSpeed ?? this.fallSpeed,
    );
  }
}
