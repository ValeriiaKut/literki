import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme.dart';

enum MascotMood { idle, wave, cheer, think, wow }

class Mascot extends StatefulWidget {
  final double size;
  final MascotMood mood;
  final Color accent;

  const Mascot({
    super.key,
    this.size = 180,
    this.mood = MascotMood.idle,
    this.accent = AppColors.accent,
  });

  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with TickerProviderStateMixin {
  late final AnimationController _bob;
  late final AnimationController _arm;
  bool _blink = false;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _bob = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _arm = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _scheduleBlink();
  }

  void _scheduleBlink() {
    final next = 2200 + math.Random().nextInt(1800);
    _blinkTimer = Timer(Duration(milliseconds: next), () {
      if (!mounted) return;
      setState(() => _blink = true);
      _blinkTimer = Timer(const Duration(milliseconds: 140), () {
        if (!mounted) return;
        setState(() => _blink = false);
        _scheduleBlink();
      });
    });
  }

  @override
  void dispose() {
    _bob.dispose();
    _arm.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bob, _arm]),
      builder: (_, _) {
        final bobT = math.sin(_bob.value * math.pi);
        double translateY;
        double rotateBody;
        switch (widget.mood) {
          case MascotMood.cheer:
            translateY = -12 * bobT;
            rotateBody = (-3 + 6 * bobT) * math.pi / 180;
            break;
          case MascotMood.idle:
          case MascotMood.wave:
            translateY = -6 * bobT;
            rotateBody = (-1 * bobT) * math.pi / 180;
            break;
          default:
            translateY = 0;
            rotateBody = 0;
        }
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.rotate(
              angle: rotateBody,
              child: CustomPaint(
                size: Size.square(widget.size),
                painter: _MascotPainter(
                  mood: widget.mood,
                  accent: widget.accent,
                  blink: _blink,
                  armPhase: math.sin(_arm.value * math.pi),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotMood mood;
  final Color accent;
  final bool blink;
  final double armPhase; // -1..1

  _MascotPainter({
    required this.mood,
    required this.accent,
    required this.blink,
    required this.armPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 200;
    canvas.scale(scale);

    final accentP = Paint()..color = accent;
    final cream = Paint()..color = AppColors.mascotCream;
    final dark = Paint()..color = AppColors.ink;
    final cheek = Paint()..color = AppColors.cheekPink.withValues(alpha: 0.6);

    // shadow
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 186), width: 96, height: 12),
      Paint()..color = const Color(0x1F000000),
    );
    // body
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 138), width: 104, height: 88),
      accentP,
    );
    // belly
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 148), width: 64, height: 56),
      cream,
    );
    // legs
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(80, 178), width: 28, height: 16),
      accentP,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(120, 178), width: 28, height: 16),
      accentP,
    );

    // arms
    void drawArm({required double pivotX, required double pivotY,
        required Offset center, required double rotation}) {
      canvas.save();
      canvas.translate(pivotX, pivotY);
      canvas.rotate(rotation);
      canvas.translate(-pivotX, -pivotY);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: 24, height: 32),
        accentP,
      );
      canvas.restore();
    }

    double leftArmAngle = 0;
    double rightArmAngle = 0;
    switch (mood) {
      case MascotMood.wave:
        leftArmAngle = (-10 + armPhase * 38) * math.pi / 180;
        break;
      case MascotMood.cheer:
        leftArmAngle = (-40 - armPhase * 25) * math.pi / 180;
        rightArmAngle = (40 + armPhase * 25) * math.pi / 180;
        break;
      case MascotMood.think:
        rightArmAngle = -30 * math.pi / 180;
        break;
      default:
        break;
    }
    drawArm(
      pivotX: 74,
      pivotY: 130,
      center: const Offset(62, 142),
      rotation: leftArmAngle,
    );
    drawArm(
      pivotX: 126,
      pivotY: 130,
      center: const Offset(138, 142),
      rotation: rightArmAngle,
    );

    // tail (simple bezier-fan)
    final tail = Path()
      ..moveTo(148, 150)
      ..quadraticBezierTo(174, 130, 168, 100)
      ..quadraticBezierTo(162, 110, 156, 122)
      ..quadraticBezierTo(150, 132, 144, 138)
      ..close();
    canvas.drawPath(tail, accentP);
    canvas.drawPath(
      Path()
        ..moveTo(162, 108)
        ..quadraticBezierTo(158, 118, 154, 124),
      Paint()
        ..color = AppColors.mascotCream
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // head
    canvas.drawCircle(const Offset(100, 80), 50, accentP);

    // ears
    final earL = Path()
      ..moveTo(56, 50)
      ..lineTo(48, 18)
      ..lineTo(78, 38)
      ..close();
    final earLInner = Path()
      ..moveTo(60, 44)
      ..lineTo(56, 28)
      ..lineTo(72, 38)
      ..close();
    final earR = Path()
      ..moveTo(144, 50)
      ..lineTo(152, 18)
      ..lineTo(122, 38)
      ..close();
    final earRInner = Path()
      ..moveTo(140, 44)
      ..lineTo(144, 28)
      ..lineTo(128, 38)
      ..close();
    canvas.drawPath(earL, accentP);
    canvas.drawPath(earLInner, cream);
    canvas.drawPath(earR, accentP);
    canvas.drawPath(earRInner, cream);

    // face mask
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 92), width: 72, height: 56),
      cream,
    );

    // eyes
    final eyeRy = blink ? 0.75 : 9.0;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(84, 84), width: 16, height: eyeRy * 2),
      dark,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(116, 84), width: 16, height: eyeRy * 2),
      dark,
    );
    if (!blink) {
      final hi = Paint()..color = Colors.white;
      canvas.drawCircle(const Offset(86, 80), 2.4, hi);
      canvas.drawCircle(const Offset(118, 80), 2.4, hi);
    }

    // cheeks
    canvas.drawCircle(const Offset(74, 100), 6, cheek);
    canvas.drawCircle(const Offset(126, 100), 6, cheek);

    // nose
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 98), width: 7, height: 5),
      dark,
    );

    // mouth
    final mouth = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = AppColors.ink;
    switch (mood) {
      case MascotMood.wow:
        canvas.drawOval(
          Rect.fromCenter(center: const Offset(100, 110), width: 10, height: 12),
          dark,
        );
        break;
      case MascotMood.cheer:
        final p = Path()
          ..moveTo(90, 106)
          ..quadraticBezierTo(100, 120, 110, 106);
        canvas.drawPath(
          p,
          Paint()..color = const Color(0xFFFF8896),
        );
        canvas.drawPath(p, mouth);
        break;
      case MascotMood.think:
        canvas.drawPath(
          Path()
            ..moveTo(92, 110)
            ..quadraticBezierTo(100, 108, 108, 112),
          mouth,
        );
        break;
      default:
        canvas.drawPath(
          Path()
            ..moveTo(92, 108)
            ..quadraticBezierTo(100, 114, 108, 108),
          mouth,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter old) =>
      old.mood != mood ||
      old.accent != accent ||
      old.blink != blink ||
      old.armPhase != armPhase;
}
