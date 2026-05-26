import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class LetterStroke {
  final int order;
  final ui.Path path;

  LetterStroke({required this.order, required this.path});
}

class LetterDefinition {
  final String letter;
  final Size viewBox;
  final List<LetterStroke> strokes;

  LetterDefinition({
    required this.letter,
    required this.viewBox,
    required this.strokes,
  });
}

class LetterAssets {
  static final Map<String, LetterDefinition?> _cache = {};

  static Future<LetterDefinition?> load(String letter) async {
    if (_cache.containsKey(letter)) return _cache[letter];
    try {
      final raw = await rootBundle.loadString('assets/letters/$letter.svg');
      final viewBoxMatch = RegExp(r'viewBox="([^"]+)"').firstMatch(raw);
      if (viewBoxMatch == null) {
        _cache[letter] = null;
        return null;
      }
      final vb = viewBoxMatch
          .group(1)!
          .trim()
          .split(RegExp(r'[\s,]+'))
          .map(double.parse)
          .toList();
      final viewBox = Size(vb[2], vb[3]);

      final pathMatches =
          RegExp(r'<path[^>]*\sd="([^"]+)"').allMatches(raw);
      final strokes = <LetterStroke>[];
      var order = 0;
      for (final match in pathMatches) {
        order++;
        strokes.add(LetterStroke(
          order: order,
          path: SvgPathParser.parse(match.group(1)!),
        ));
      }
      if (strokes.isEmpty) {
        _cache[letter] = null;
        return null;
      }
      final def = LetterDefinition(
        letter: letter,
        viewBox: viewBox,
        strokes: strokes,
      );
      _cache[letter] = def;
      return def;
    } catch (_) {
      _cache[letter] = null;
      return null;
    }
  }
}

void paintLetterStrokes(
  Canvas canvas,
  Size canvasSize,
  LetterDefinition definition, {
  required Color color,
  required double strokeWidth,
}) {
  final scaleX = canvasSize.width / definition.viewBox.width;
  final scaleY = canvasSize.height / definition.viewBox.height;
  final scale = scaleX < scaleY ? scaleX : scaleY;
  final tx = (canvasSize.width - definition.viewBox.width * scale) / 2;
  final ty = (canvasSize.height - definition.viewBox.height * scale) / 2;

  canvas.save();
  canvas.translate(tx, ty);
  canvas.scale(scale);

  final paint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  for (final stroke in definition.strokes) {
    canvas.drawPath(stroke.path, paint);
  }
  canvas.restore();
}

class SvgPathParser {
  static ui.Path parse(String d) {
    final path = ui.Path();
    final tokens = _tokenize(d);
    var i = 0;
    double cx = 0, cy = 0;
    double startX = 0, startY = 0;
    String? lastCmd;

    double next() => double.parse(tokens[i++]);

    while (i < tokens.length) {
      final token = tokens[i];
      final isCmd = token.length == 1 &&
          ((token.codeUnitAt(0) >= 0x41 && token.codeUnitAt(0) <= 0x5A) ||
              (token.codeUnitAt(0) >= 0x61 && token.codeUnitAt(0) <= 0x7A));
      String cmd;
      if (isCmd) {
        cmd = token;
        i++;
      } else {
        final prev = lastCmd;
        if (prev == null) {
          throw const FormatException('SVG path must start with a command');
        }
        cmd = switch (prev) {
          'M' => 'L',
          'm' => 'l',
          _ => prev,
        };
      }
      lastCmd = cmd;

      switch (cmd) {
        case 'M':
          final x = next();
          final y = next();
          path.moveTo(x, y);
          cx = x;
          cy = y;
          startX = x;
          startY = y;
        case 'm':
          final dx = next();
          final dy = next();
          cx += dx;
          cy += dy;
          path.moveTo(cx, cy);
          startX = cx;
          startY = cy;
        case 'L':
          final x = next();
          final y = next();
          path.lineTo(x, y);
          cx = x;
          cy = y;
        case 'l':
          final dx = next();
          final dy = next();
          cx += dx;
          cy += dy;
          path.lineTo(cx, cy);
        case 'H':
          final x = next();
          path.lineTo(x, cy);
          cx = x;
        case 'h':
          cx += next();
          path.lineTo(cx, cy);
        case 'V':
          final y = next();
          path.lineTo(cx, y);
          cy = y;
        case 'v':
          cy += next();
          path.lineTo(cx, cy);
        case 'C':
          final x1 = next(), y1 = next();
          final x2 = next(), y2 = next();
          final x = next(), y = next();
          path.cubicTo(x1, y1, x2, y2, x, y);
          cx = x;
          cy = y;
        case 'c':
          final x1 = cx + next(), y1 = cy + next();
          final x2 = cx + next(), y2 = cy + next();
          final x = cx + next(), y = cy + next();
          path.cubicTo(x1, y1, x2, y2, x, y);
          cx = x;
          cy = y;
        case 'Q':
          final x1 = next(), y1 = next();
          final x = next(), y = next();
          path.quadraticBezierTo(x1, y1, x, y);
          cx = x;
          cy = y;
        case 'q':
          final x1 = cx + next(), y1 = cy + next();
          final x = cx + next(), y = cy + next();
          path.quadraticBezierTo(x1, y1, x, y);
          cx = x;
          cy = y;
        case 'Z':
        case 'z':
          path.close();
          cx = startX;
          cy = startY;
        default:
          throw FormatException('Unsupported SVG path command: $cmd');
      }
    }
    return path;
  }

  static List<String> _tokenize(String d) {
    final spaced =
        d.replaceAllMapped(RegExp(r'[a-zA-Z]'), (m) => ' ${m[0]} ');
    final withMinus = spaced.replaceAllMapped(
        RegExp(r'(\d)-'), (m) => '${m[1]} -');
    return withMinus
        .split(RegExp(r'[\s,]+'))
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
