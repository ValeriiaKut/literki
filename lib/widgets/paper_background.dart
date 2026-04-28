import 'package:flutter/material.dart';
import '../theme.dart';

enum PaperVariant { lines, dots }

class PaperBackground extends StatelessWidget {
  final PaperVariant variant;
  const PaperBackground({super.key, this.variant = PaperVariant.lines});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _PaperPainter(variant: variant)),
      ),
    );
  }
}

class _PaperPainter extends CustomPainter {
  final PaperVariant variant;
  _PaperPainter({required this.variant});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.paperLine;
    if (variant == PaperVariant.lines) {
      const spacing = 96.0;
      for (double y = 95; y < size.height; y += spacing) {
        canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1.5), paint);
      }
    } else {
      const spacing = 24.0;
      const radius = 1.4;
      for (double y = spacing / 2; y < size.height; y += spacing) {
        for (double x = spacing / 2; x < size.width; x += spacing) {
          canvas.drawCircle(Offset(x, y), radius, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PaperPainter old) => old.variant != variant;
}
