import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import 'mascot.dart';
import 'star.dart';

/// Round icon button used across the reading screens (back / speaker).
class ReadingRoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;
  final double size;
  const ReadingRoundButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.cardBg,
    this.iconColor = AppColors.ink,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: cardShadow,
          ),
          child: Icon(icon, color: iconColor, size: size * 0.46),
        ),
      ),
    );
  }
}

/// Title bar shared by the three reading levels: back button, a coloured pill
/// title, and a speaker button that re-speaks the current prompt.
class ReadingTopBar extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onSpeak;
  const ReadingTopBar({
    super.key,
    required this.title,
    required this.color,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReadingRoundButton(
          icon: Icons.arrow_back,
          color: color,
          iconColor: Colors.white,
          onTap: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: cardShadow,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Handwriting',
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: color,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ReadingRoundButton(
          icon: Icons.volume_up_rounded,
          color: color,
          iconColor: Colors.white,
          onTap: onSpeak,
        ),
      ],
    );
  }
}

/// A celebratory burst: mascot, a few popping stars, and an encouraging line.
/// Used by the repeat-practice dialog and the level-3 success overlay.
class ReadingCelebration extends StatefulWidget {
  final String message;
  final MascotMood mood;
  final double mascotSize;
  const ReadingCelebration({
    super.key,
    required this.message,
    this.mood = MascotMood.cheer,
    this.mascotSize = 130,
  });

  @override
  State<ReadingCelebration> createState() => _ReadingCelebrationState();
}

class _ReadingCelebrationState extends State<ReadingCelebration>
    with TickerProviderStateMixin {
  late final AnimationController _burst;
  late final List<_Spark> _sparks;

  @override
  void initState() {
    super.initState();
    _burst = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    final rng = math.Random(widget.message.length + widget.mascotSize.toInt());
    _sparks = List.generate(12, (i) {
      final angle = (i / 12) * 2 * math.pi;
      return _Spark(
        angle: angle,
        dist: 90 + rng.nextDouble() * 50,
        delay: rng.nextDouble() * 0.2,
        size: 14 + rng.nextDouble() * 12,
      );
    });
  }

  @override
  void dispose() {
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.mascotSize,
          width: widget.mascotSize + 80,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              for (final s in _sparks)
                AnimatedBuilder(
                  animation: _burst,
                  builder: (_, _) {
                    final localT =
                        ((_burst.value - s.delay) / (1 - s.delay))
                            .clamp(0.0, 1.0);
                    final ease = Curves.easeOut.transform(localT);
                    final opacity =
                        ease < 0.2 ? ease * 5 : 1 - (ease - 0.2) / 0.8;
                    return Transform.translate(
                      offset: Offset(
                        math.cos(s.angle) * s.dist * ease,
                        math.sin(s.angle) * s.dist * ease,
                      ),
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: ease,
                          child: StarIcon(filled: true, size: s.size),
                        ),
                      ),
                    );
                  },
                ),
              Mascot(size: widget.mascotSize, mood: widget.mood),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _Spark {
  final double angle;
  final double dist;
  final double delay;
  final double size;
  _Spark({
    required this.angle,
    required this.dist,
    required this.delay,
    required this.size,
  });
}

/// Big circular microphone button. Pulses while [listening] is true.
class MicButton extends StatefulWidget {
  final bool listening;
  final VoidCallback onTap;
  final Color color;
  const MicButton({
    super.key,
    required this.listening,
    required this.onTap,
    this.color = AppColors.accent,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.listening) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant MicButton old) {
    super.didUpdateWidget(old);
    if (widget.listening && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.listening && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.listening ? AppColors.accent2 : widget.color;
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, child) {
          final t = Curves.easeInOut.transform(_pulse.value);
          return Stack(
            alignment: Alignment.center,
            children: [
              if (widget.listening)
                Container(
                  width: 96 + 36 * t,
                  height: 96 + 36 * t,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent2.withValues(alpha: 0.18 * (1 - t)),
                  ),
                ),
              child!,
            ],
          );
        },
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: base,
            boxShadow: cardShadow,
          ),
          child: Icon(
            widget.listening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
            color: Colors.white,
            size: 44,
          ),
        ),
      ),
    );
  }
}
