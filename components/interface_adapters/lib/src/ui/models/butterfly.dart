import 'dart:ui';

class Butterfly {
  const Butterfly({
    required this.offset,
    required this.size,
    required this.direction,
    required this.flapAngle,
    required this.speed,
    required this.rotationAngle,
    required this.isUpsideDown,
    required this.flutterPhase,
    required this.blinkPhase,
  });

  final Offset offset;
  final double size;
  final double direction;

  /// A value that continuously changes to drive other animations, such as:
  /// 	•	Swaying left and right
  /// 	•	Vertical drifting
  /// 	•	Or even wing-flap-style effects
  final double flapAngle;
  final double speed;
  final double rotationAngle;
  final bool isUpsideDown;

  /// Offsets the butterfly’s fluttering animation so that not all butterflies
  /// blink (disappear) at the same time.
  final int flutterPhase;
  final double blinkPhase;

  Butterfly copyWith({
    Offset? offset,
    double? size,
    double? direction,
    double? flapAngle,
    double? speed,
    double? rotationAngle,
    bool? isUpsideDown,
    int? flutterPhase,
    double? blinkPhase,
  }) {
    return Butterfly(
      offset: offset ?? this.offset,
      size: size ?? this.size,
      direction: direction ?? this.direction,
      flapAngle: flapAngle ?? this.flapAngle,
      speed: speed ?? this.speed,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      isUpsideDown: isUpsideDown ?? this.isUpsideDown,
      flutterPhase: flutterPhase ?? this.flutterPhase,
      blinkPhase: blinkPhase ?? this.blinkPhase,
    );
  }
}
