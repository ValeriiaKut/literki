import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/big_button.dart';
import '../widgets/mascot.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _intro;
  late final List<_FloatLetter> _floats;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
    final rng = math.Random();
    const sample = ['A', 'b', 'Ą', 'ć', 'D', 'e', 'Ł', 'o', 'Ś', 'ż'];
    _floats = List.generate(sample.length, (i) {
      return _FloatLetter(
        letter: sample[i],
        x: 0.05 + (i % 5) * 0.19 + rng.nextDouble() * 0.06,
        y: 0.08 + (i ~/ 5) * 0.65 + rng.nextDouble() * 0.1,
        size: 60 + rng.nextDouble() * 40,
        rot: (-15 + rng.nextDouble() * 30) * math.pi / 180,
        delay: i * 0.3,
        hue: i % 3,
      );
    });
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _intro.dispose();
    super.dispose();
  }

  Color _hueColor(int h) =>
      [AppColors.accent, AppColors.accent2, AppColors.accent3][h];

  double _progress(double start, double end, [Curve curve = Curves.easeOut]) {
    final t = ((_intro.value - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(t);
  }

  Widget _slideUp({
    required double start,
    required double end,
    required Widget child,
    double translateY = 16,
    Curve curve = Curves.easeOut,
  }) {
    final t = _progress(start, end, curve);
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, translateY * (1 - t)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.accent3.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.accent2.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _floatCtrl,
            builder: (context, _) {
              return LayoutBuilder(builder: (context, c) {
                return Stack(
                  children: _floats.map((f) {
                    final phase =
                        math.sin((_floatCtrl.value + f.delay) * math.pi);
                    return Positioned(
                      left: f.x * c.maxWidth,
                      top: f.y * c.maxHeight + phase * -12,
                      child: Transform.rotate(
                        angle: f.rot,
                        child: Text(
                          f.letter,
                          style: TextStyle(
                            fontFamily: 'Handwriting',
                            fontWeight: FontWeight.w700,
                            fontSize: f.size,
                            color: _hueColor(f.hue).withValues(alpha: 0.18),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              });
            },
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: AnimatedBuilder(
                  animation: _intro,
                  builder: (context, _) {
                    final mascotT = _progress(0.3, 0.85, Curves.elasticOut);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _slideUp(
                          start: 0.0,
                          end: 0.5,
                          translateY: 24,
                          child: _Title(),
                        ),
                        const SizedBox(height: 12),
                        _slideUp(
                          start: 0.15,
                          end: 0.65,
                          child: const Text(
                            'Naucz się pisać litery — to zabawa!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: AppColors.inkSoft,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Opacity(
                          opacity: mascotT.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: 0.5 + 0.5 * mascotT,
                            child:
                                const Mascot(size: 200, mood: MascotMood.wave),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _slideUp(
                          start: 0.6,
                          end: 1.0,
                          child: BigButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.white),
                            child: const Text('Zaczynamy!'),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _slideUp(
                          start: 0.75,
                          end: 1.0,
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: const [
                              _Chip(icon: Icons.abc, label: 'Cały alfabet'),
                              _Chip(
                                  icon: Icons.star_rounded,
                                  label: 'Zbieraj gwiazdki'),
                              _Chip(
                                  icon: Icons.flag_rounded, label: '3 poziomy'),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontFamily: 'Handwriting',
            fontWeight: FontWeight.w800,
            fontSize: 140,
            height: 0.9,
            color: AppColors.ink,
            letterSpacing: 4,
          ),
          children: [
            TextSpan(text: 'Lite'),
            TextSpan(text: 'r', style: TextStyle(color: AppColors.diacritic)),
            TextSpan(text: 'k'),
            TextSpan(text: 'i', style: TextStyle(color: AppColors.accent)),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: AppColors.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatLetter {
  final String letter;
  final double x;
  final double y;
  final double size;
  final double rot;
  final double delay;
  final int hue;
  _FloatLetter({
    required this.letter,
    required this.x,
    required this.y,
    required this.size,
    required this.rot,
    required this.delay,
    required this.hue,
  });
}
