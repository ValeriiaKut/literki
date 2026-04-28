import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/big_button.dart';
import '../widgets/mascot.dart';
import '../widgets/star.dart';

class SuccessDialog extends StatefulWidget {
  final int score; // 0..5
  final String letter;
  final bool isDiacritic;
  final bool hasNext;
  final VoidCallback onRetry;
  final VoidCallback onNext;

  const SuccessDialog({
    super.key,
    required this.score,
    required this.letter,
    required this.isDiacritic,
    required this.hasNext,
    required this.onRetry,
    required this.onNext,
  });

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog>
    with TickerProviderStateMixin {
  late final AnimationController _pop;
  late final AnimationController _burst;
  late final AnimationController _stars;
  late final List<_BurstStar> _burstStars;

  static const _messages = [
    'Spróbuj jeszcze raz!',
    'Coraz lepiej!',
    'Bardzo dobrze!',
    'Świetnie!',
    'Doskonale!',
    'Doskonale!',
  ];
  static const _moods = [
    MascotMood.think,
    MascotMood.idle,
    MascotMood.cheer,
    MascotMood.cheer,
    MascotMood.wow,
    MascotMood.wow,
  ];

  @override
  void initState() {
    super.initState();
    _pop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _burst = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _stars = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    final rng = math.Random();
    _burstStars = widget.score >= 3
        ? List.generate(16, (i) {
            final angle = (i / 16) * 2 * math.pi;
            return _BurstStar(
              angle: angle,
              dist: 130 + rng.nextDouble() * 60,
              delay: rng.nextDouble() * 0.2,
              size: 14 + rng.nextDouble() * 12,
            );
          })
        : [];
    if (widget.score >= 3) _burst.forward();
    if (widget.score > 0) _stars.forward();
  }

  @override
  void dispose() {
    _pop.dispose();
    _burst.dispose();
    _stars.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.score;
    final message = score == 0
        ? 'Najpierw narysuj literę!'
        : _messages[score];
    final mood = score == 0 ? MascotMood.think : _moods[score];

    return GestureDetector(
      onTap: () {}, // swallow taps on the scrim's children
      child: Container(
        color: const Color(0x73140F0A),
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: _pop,
          builder: (_, child) {
            final t = Curves.elasticOut.transform(_pop.value.clamp(0, 1));
            final scale = 0.7 + 0.3 * t;
            return Opacity(opacity: _pop.value, child: Transform.scale(scale: scale, child: child));
          },
          child: Container(
            width: 480,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.fromLTRB(28, 80, 28, 24),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D000000),
                  blurRadius: 60,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Burst stars
                for (final b in _burstStars)
                  AnimatedBuilder(
                    animation: _burst,
                    builder: (_, _) {
                      final localT =
                          ((_burst.value - b.delay) / (1 - b.delay))
                              .clamp(0.0, 1.0);
                      final ease = Curves.easeOut.transform(localT);
                      final dx = math.cos(b.angle) * b.dist * ease;
                      final dy = math.sin(b.angle) * b.dist * ease;
                      final opacity = ease < 0.2
                          ? ease * 5
                          : 1 - (ease - 0.2) / 0.8;
                      return Positioned(
                        top: 60 + dy - b.size / 2,
                        left: 240 - 24 + dx - b.size / 2,
                        child: Opacity(
                          opacity: opacity.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: ease,
                            child: StarIcon(filled: true, size: b.size),
                          ),
                        ),
                      );
                    },
                  ),
                Positioned(
                  top: -90,
                  child: Mascot(size: 150, mood: mood),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    if (score > 0)
                      AnimatedBuilder(
                        animation: _stars,
                        builder: (_, _) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (i) {
                            final start = 0.1 + i * 0.12;
                            final end = (start + 0.4).clamp(0.0, 1.0);
                            final t = ((_stars.value - start) /
                                    (end - start))
                                .clamp(0.0, 1.0);
                            final ease = Curves.easeOutBack.transform(t);
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Opacity(
                                opacity: t,
                                child: Transform.rotate(
                                  angle: (-30 * (1 - t)) * math.pi / 180,
                                  child: Transform.scale(
                                    scale: ease,
                                    child: StarIcon(
                                      filled: i < score,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    if (score > 0) ...[
                      const SizedBox(height: 12),
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            color: AppColors.inkSoft,
                            fontSize: 16,
                          ),
                          children: [
                            const TextSpan(text: 'Litera '),
                            TextSpan(
                              text: widget.letter,
                              style: TextStyle(
                                fontFamily: 'Handwriting',
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: widget.isDiacritic
                                    ? AppColors.diacritic
                                    : AppColors.ink,
                              ),
                            ),
                            const TextSpan(text: ' ukończona!'),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        BigButton(
                          size: BigButtonSize.md,
                          color: AppColors.bgSoft,
                          textColor: AppColors.ink,
                          onPressed: widget.onRetry,
                          child: const Text('Jeszcze raz'),
                        ),
                        if (widget.hasNext && score > 0)
                          BigButton(
                            size: BigButtonSize.md,
                            color: AppColors.success,
                            onPressed: widget.onNext,
                            child: const Text('Następna →'),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BurstStar {
  final double angle;
  final double dist;
  final double delay;
  final double size;
  _BurstStar({
    required this.angle,
    required this.dist,
    required this.delay,
    required this.size,
  });
}
