import 'package:flutter/material.dart';
import '../theme.dart';

class StarIcon extends StatelessWidget {
  final bool filled;
  final double size;

  const StarIcon({super.key, required this.filled, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _StarPainter(filled: filled),
    );
  }
}

class _StarPainter extends CustomPainter {
  final bool filled;
  _StarPainter({required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    final path = Path()
      ..moveTo(12 * scale, 2 * scale)
      ..lineTo(14.9 * scale, 8.6 * scale)
      ..lineTo(22 * scale, 9.3 * scale)
      ..lineTo(16.6 * scale, 14 * scale)
      ..lineTo(18.3 * scale, 21 * scale)
      ..lineTo(12 * scale, 17.3 * scale)
      ..lineTo(5.7 * scale, 21 * scale)
      ..lineTo(7.4 * scale, 14 * scale)
      ..lineTo(2 * scale, 9.3 * scale)
      ..lineTo(9.1 * scale, 8.6 * scale)
      ..close();

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = filled ? AppColors.starGold : const Color(0x1A000000);
    canvas.drawPath(path, fill);

    if (filled) {
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = scale
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.starGoldEdge;
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.filled != filled;
}

class StarRow extends StatelessWidget {
  final int count;
  final int total;
  final double size;
  final double gap;

  const StarRow({
    super.key,
    required this.count,
    this.total = 5,
    this.size = 22,
    this.gap = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i == total - 1 ? 0 : gap),
          child: StarIcon(filled: i < count, size: size),
        );
      }),
    );
  }
}
