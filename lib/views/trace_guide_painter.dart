import 'dart:math';
import 'package:flutter/material.dart';

import '../models/letter_trace.dart';
import '../theme.dart';

class TraceGuidePainter extends CustomPainter {
  final LetterTrace trace;

  TraceGuidePainter(this.trace);

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.inkSoft.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final bigDotPaint = Paint()
      ..color = AppColors.inkSoft.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    final startDotPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.fill;

    for (int strokeIndex = 0; strokeIndex < trace.strokes.length; strokeIndex++) {
      final stroke = trace.strokes[strokeIndex];

      final dots = stroke
          .map((point) => Offset(point.dx * size.width, point.dy * size.height))
          .toList();

      for (int i = 0; i < dots.length; i++) {
        final isStart = i == 0;
        final isEnd = i == dots.length - 1;
        final isFirstLetterPoint = strokeIndex == 0 && isStart;

        canvas.drawCircle(
          dots[i],
          isFirstLetterPoint
              ? 16
              : (isStart || isEnd)
              ? 14
              : 6,
          isFirstLetterPoint
              ? startDotPaint
              : (isStart || isEnd)
              ? bigDotPaint
              : dotPaint,
        );
      }

      for (final arrow in trace.arrows) {
        if (arrow.strokeIndex == strokeIndex) {
          _drawArrowSafe(
            canvas,
            dots,
            arrow.fromIndex,
            arrow.toIndex,
          );
        }
      }
    }

    if (trace.strokes.isEmpty || trace.strokes.first.isEmpty) return;

    final firstPoint = trace.strokes.first.first;
    final firstDot = Offset(
      firstPoint.dx * size.width,
      firstPoint.dy * size.height,
    );

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'START',
        style: TextStyle(
          color: AppColors.success,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, firstDot + const Offset(-4, 18));
  }

  void _drawArrowSafe(
      Canvas canvas,
      List<Offset> dots,
      int fromIndex,
      int toIndex,
      ) {
    if (dots.length < 2) return;

    final maxIndex = dots.length - 1;

    final safeFrom = fromIndex.clamp(0, maxIndex);
    final safeTo = toIndex.clamp(0, maxIndex);

    if (safeFrom == safeTo) return;

    _drawArrow(canvas, dots[safeFrom], dots[safeTo]);
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to) {
    final paint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(from, to, paint);

    final angle = atan2(to.dy - from.dy, to.dx - from.dx);
    const arrowSize = 24.0;

    final p1 = Offset(
      to.dx - arrowSize * cos(angle - pi / 6),
      to.dy - arrowSize * sin(angle - pi / 6),
    );

    final p2 = Offset(
      to.dx - arrowSize * cos(angle + pi / 6),
      to.dy - arrowSize * sin(angle + pi / 6),
    );

    canvas.drawLine(to, p1, paint);
    canvas.drawLine(to, p2, paint);
  }

  @override
  bool shouldRepaint(covariant TraceGuidePainter oldDelegate) {
    return oldDelegate.trace != trace;
  }
}