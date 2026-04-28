import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double strokeWidth;

  DrawingPainter(
    this.points, {
    this.color = Colors.black,
    this.strokeWidth = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
