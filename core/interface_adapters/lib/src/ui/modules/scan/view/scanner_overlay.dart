import 'package:flutter/material.dart';

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  final double _borderRadius = 12.0;
  final double _strokeWidth = 6.0;
  final double _borderRadiusMultiplier = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Create a `Paint` object for the `Colors.green` border.
    final Paint borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    // Create a `Path` object for the rounded corners.
    final Path cornersPath = Path()
      // Start from the top left corner.
      ..moveTo(
        scanWindow.left + _borderRadius,
        scanWindow.top,
      )
      ..lineTo(
        scanWindow.left + _borderRadiusWithMultiplier,
        scanWindow.top,
      )
      // Move to the top right corner.
      ..moveTo(
        scanWindow.right - _borderRadiusWithMultiplier,
        scanWindow.top,
      )
      // Move to the right.
      ..lineTo(
        scanWindow.right - _borderRadius,
        scanWindow.top,
      )
      ..quadraticBezierTo(
        scanWindow.right, scanWindow.top, // Control point
        scanWindow.right, scanWindow.top + _borderRadius, // End point
      )
      // Move down.
      ..lineTo(
        scanWindow.right,
        scanWindow.top + _borderRadiusWithMultiplier,
      )
      ..moveTo(
        scanWindow.right,
        scanWindow.bottom - _borderRadiusWithMultiplier,
      )
      // Move down.
      ..lineTo(scanWindow.right, scanWindow.bottom - _borderRadius)
      ..quadraticBezierTo(
        scanWindow.right, scanWindow.bottom, // Control point
        scanWindow.right - _borderRadius, scanWindow.bottom, // End point
      )
      ..lineTo(
        scanWindow.right - _borderRadiusWithMultiplier,
        scanWindow.bottom,
      )
      ..moveTo(
        scanWindow.left + _borderRadiusWithMultiplier,
        scanWindow.bottom,
      )
      // Move to the left.
      ..lineTo(
        scanWindow.left + _borderRadius,
        scanWindow.bottom,
      )
      ..quadraticBezierTo(
        scanWindow.left, scanWindow.bottom, // Control point
        scanWindow.left, scanWindow.bottom - _borderRadius, // End point
      )
      // Move up.
      ..lineTo(
        scanWindow.left,
        scanWindow.bottom - _borderRadiusWithMultiplier,
      )
      // Move to the starting point.
      ..moveTo(
        scanWindow.left,
        scanWindow.top + _borderRadiusWithMultiplier,
      )
      ..lineTo(scanWindow.left, scanWindow.top + _borderRadius)
      ..quadraticBezierTo(
        // Control point.
        scanWindow.left, scanWindow.top,
        // End point.
        scanWindow.left + _borderRadius, scanWindow.top,
      );

    // Draw the white rounded corners
    canvas.drawPath(cornersPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double get _borderRadiusWithMultiplier =>
      _borderRadius * _borderRadiusMultiplier;
}
