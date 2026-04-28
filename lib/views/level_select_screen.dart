import 'package:flutter/material.dart';

import '../data/alphabet.dart';
import '../state/progress_store.dart';
import '../theme.dart';
import '../widgets/paper_background.dart';
import '../widgets/star.dart';
import 'draw_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  final String letter;
  const LevelSelectScreen({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    final isDia = polishDiacritics.contains(letter);
    final levels = const [
      _LevelInfo(
        n: 1,
        name: 'Łatwy',
        desc: 'Cała litera widoczna — pisz po szarej linii',
        emoji: '🐣',
        color: AppColors.accent2,
      ),
      _LevelInfo(
        n: 2,
        name: 'Średni',
        desc: 'Tylko obrys — pisz wewnątrz linii',
        emoji: '🐰',
        color: AppColors.accent,
      ),
      _LevelInfo(
        n: 3,
        name: 'Trudny',
        desc: 'Sam(a)! Spróbuj bez pomocy',
        emoji: '🦁',
        color: AppColors.accent3,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const PaperBackground(variant: PaperVariant.dots),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _RoundButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Wybierz poziom dla litery',
                        style: TextStyle(
                          fontSize: 22,
                          color: AppColors.inkSoft,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LayoutBuilder(builder: (context, c) {
                      final wide = c.maxWidth >= 700;
                      final letterCard = _BigLetterCard(
                        letter: letter,
                        isDia: isDia,
                        size: wide ? null : 160,
                      );
                      final levelList = Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < levels.length; i++) ...[
                            _LevelCard(
                              letter: letter,
                              info: levels[i],
                              delay: Duration(milliseconds: i * 100),
                            ),
                            if (i < levels.length - 1)
                              const SizedBox(height: 12),
                          ],
                        ],
                      );
                      if (wide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AspectRatio(aspectRatio: 1, child: letterCard),
                            const SizedBox(width: 24),
                            Expanded(child: levelList),
                          ],
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Center(child: letterCard),
                            const SizedBox(height: 16),
                            levelList,
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BigLetterCard extends StatelessWidget {
  final String letter;
  final bool isDia;
  final double? size;

  const _BigLetterCard({
    required this.letter,
    required this.isDia,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(28),
        boxShadow: cardShadow,
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            letter,
            style: TextStyle(
              fontFamily: 'Handwriting',
              fontSize: 200,
              fontWeight: FontWeight.w800,
              height: 1,
              color: isDia ? AppColors.diacritic : AppColors.ink,
            ),
          ),
        ),
      ),
    );
    return card;
  }
}

class _LevelInfo {
  final int n;
  final String name;
  final String desc;
  final String emoji;
  final Color color;
  const _LevelInfo({
    required this.n,
    required this.name,
    required this.desc,
    required this.emoji,
    required this.color,
  });
}

class _LevelCard extends StatefulWidget {
  final String letter;
  final _LevelInfo info;
  final Duration delay;
  const _LevelCard({
    required this.letter,
    required this.info,
    required this.delay,
  });

  @override
  State<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<_LevelCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _enter.forward();
    });
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _enter,
      builder: (_, child) {
        final t = Curves.easeOut.transform(_enter.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - t)),
            child: child,
          ),
        );
      },
      child: ListenableBuilder(
        listenable: ProgressStore.instance,
        builder: (context, _) {
          final stars = ProgressStore.instance
              .starsFor(widget.letter, widget.info.n);
          return Material(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DrawScreen(
                    letter: widget.letter,
                    level: widget.info.n,
                  ),
                ));
              },
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: cardShadow,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: widget.info.color,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.info.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                widget.info.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '· Poziom ${widget.info.n}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.inkSoft,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.info.desc,
                            style: const TextStyle(
                              color: AppColors.inkSoft,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StarRow(count: stars, size: 16, gap: 2),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right,
                        color: AppColors.inkSoft, size: 28),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: cardShadow,
          ),
          child: Icon(icon, color: AppColors.ink, size: 22),
        ),
      ),
    );
  }
}
