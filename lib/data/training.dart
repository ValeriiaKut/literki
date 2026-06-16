import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Builds a single horizontal row of a pre-writing pattern.
///
/// [width] is the usable width, [centerY] the vertical centre of the row and
/// [rowHeight] the vertical space the row may occupy. Coordinates start at
/// x = 0; the painter shifts the whole path by the left padding.
typedef RowBuilder = Path Function(double width, double centerY, double rowHeight);

/// A pre-writing ("Trening") exercise: a repeating shape the child traces to
/// warm up the hand. These are not scored — see [TrainingScreen].
class TrainingPattern {
  final String id;
  final String label;
  final String hint;

  /// When true the guide is drawn as a row of dots to connect rather than a
  /// continuous line.
  final bool dotted;
  final RowBuilder row;

  const TrainingPattern({
    required this.id,
    required this.label,
    required this.hint,
    required this.row,
    this.dotted = false,
  });
}

const List<TrainingPattern> trainingPatterns = [
  TrainingPattern(
    id: 'linie',
    label: 'Linie',
    hint: 'Rysuj proste kreski z góry na dół.',
    row: _linesRow,
  ),
  TrainingPattern(
    id: 'fale',
    label: 'Fale',
    hint: 'Płynnie rysuj fale po szarym śladzie.',
    row: _wavesRow,
  ),
  TrainingPattern(
    id: 'zygzaki',
    label: 'Zygzaki',
    hint: 'Rysuj ostre ząbki: w górę i w dół.',
    row: _zigzagRow,
  ),
  TrainingPattern(
    id: 'petle',
    label: 'Pętle',
    hint: 'Rysuj okrągłe pętelki bez odrywania ręki.',
    row: _loopsRow,
  ),
  TrainingPattern(
    id: 'kola',
    label: 'Kółka',
    hint: 'Rysuj okrągłe kółka po śladzie.',
    row: _circlesRow,
  ),
  TrainingPattern(
    id: 'kropki',
    label: 'Kropki',
    hint: 'Połącz kropki jedną linią.',
    row: _wavesRow,
    dotted: true,
  ),
];

TrainingPattern trainingPatternById(String id) =>
    trainingPatterns.firstWhere((p) => p.id == id);

// ---------------------------------------------------------------------------
// Row builders
// ---------------------------------------------------------------------------

Path _linesRow(double width, double cy, double h) {
  final p = Path();
  final amp = h * 0.38;
  final slant = h * 0.16;
  final step = h * 0.55;
  for (double x = step; x < width; x += step) {
    p.moveTo(x + slant, cy - amp);
    p.lineTo(x - slant, cy + amp);
  }
  return p;
}

Path _wavesRow(double width, double cy, double h) {
  final p = Path();
  final amp = h * 0.30;
  final wl = h * 1.1;
  var first = true;
  for (double x = 0; x <= width; x += 4) {
    final y = cy - amp * math.sin(x / wl * 2 * math.pi);
    if (first) {
      p.moveTo(x, y);
      first = false;
    } else {
      p.lineTo(x, y);
    }
  }
  return p;
}

Path _zigzagRow(double width, double cy, double h) {
  final p = Path();
  final amp = h * 0.32;
  final step = h * 0.5;
  p.moveTo(0, cy + amp);
  var up = true;
  for (double x = 0; x < width; x += step) {
    p.lineTo(x + step, up ? cy - amp : cy + amp);
    up = !up;
  }
  return p;
}

Path _loopsRow(double width, double cy, double h) {
  final p = Path();
  final amp = h * 0.34;
  final step = h * 0.7;
  p.moveTo(0, cy + amp);
  for (double x = 0; x < width; x += step) {
    // Crossed control points (first to the right, second to the left) make the
    // curve loop back on itself like a cursive "l".
    p.cubicTo(
      x + step * 0.95, cy - amp,
      x + step * 0.05, cy - amp,
      x + step, cy + amp,
    );
  }
  return p;
}

Path _circlesRow(double width, double cy, double h) {
  final p = Path();
  final r = h * 0.34;
  final step = r * 2.5;
  for (double cx = r + step * 0.1; cx + r < width; cx += step) {
    p.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
  }
  return p;
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

/// Draws the grey traceable guide for a [TrainingPattern], laid out as evenly
/// spaced workbook rows. Used both for the full practice canvas and (with
/// [rows] = 1) for the small preview on the menu tile.
class TrainingGuidePainter extends CustomPainter {
  final TrainingPattern pattern;
  final int rows;
  final double strokeWidth;
  final Color color;

  const TrainingGuidePainter(
    this.pattern, {
    this.rows = 3,
    this.strokeWidth = 6,
    this.color = AppColors.guideInk,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pad = size.width * 0.06;
    final usableW = size.width - pad * 2;
    // Distribute the rows with equal margins top and bottom so the block sits
    // centred in the canvas (rows at 1/(n+1), 2/(n+1), …).
    final band = size.height / (rows + 1);

    for (var i = 0; i < rows; i++) {
      final cy = band * (i + 1);
      final path =
          pattern.row(usableW, cy, band * 0.8).shift(Offset(pad, 0));
      if (pattern.dotted) {
        _drawDots(canvas, path, color, band);
      } else {
        canvas.drawPath(path, stroke);
      }
    }
  }

  void _drawDots(Canvas canvas, Path path, Color color, double rowH) {
    final dot = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final spacing = rowH * 0.42;
    final radius = strokeWidth * 0.7;
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d <= metric.length; d += spacing) {
        final tan = metric.getTangentForOffset(d);
        if (tan != null) canvas.drawCircle(tan.position, radius, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TrainingGuidePainter oldDelegate) =>
      oldDelegate.pattern.id != pattern.id || oldDelegate.rows != rows;
}
