import 'package:flutter/material.dart';

import '../data/module.dart';
import '../state/progress_store.dart';
import '../state/speech_service.dart';
import '../theme.dart';
import '../widgets/star.dart';
import 'reading_match_screen.dart';
import 'reading_syllables_screen.dart';
import 'reading_words_screen.dart';

/// The reading module home: three level cards (sylaby → wyrazy → przeczytaj i
/// wskaż). Rendered inside [HomeScreen] when the Czytanie module is selected,
/// mirroring how the training module gets its own grid.
class ReadingMenu extends StatelessWidget {
  const ReadingMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = <_ReadingLevel>[
      _ReadingLevel(
        n: 1,
        title: 'Czytam sylaby',
        desc: 'Poznaj i powtarzaj sylaby',
        emoji: '🔤',
        color: AppColors.accent,
        builder: (_) => const ReadingSyllablesScreen(),
      ),
      _ReadingLevel(
        n: 2,
        title: 'Czytam wyrazy',
        desc: 'Czytaj wyrazy z obrazkiem',
        emoji: '🖼️',
        color: AppColors.accent3,
        builder: (_) => const ReadingWordsScreen(),
      ),
      _ReadingLevel(
        n: 3,
        title: 'Przeczytaj i wskaż',
        desc: 'Dopasuj wyraz do obrazka',
        emoji: '🔎',
        color: AppColors.accent2,
        builder: (_) => const ReadingMatchScreen(),
      ),
    ];

    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth >= 700;
      final list = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < levels.length; i++) ...[
            _ReadingLevelCard(level: levels[i], delay: Duration(milliseconds: i * 100)),
            if (i < levels.length - 1) const SizedBox(height: 14),
          ],
        ],
      );
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: wide ? 40 : 4, vertical: 8),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: list,
        )),
      );
    });
  }
}

class _ReadingLevel {
  final int n;
  final String title;
  final String desc;
  final String emoji;
  final Color color;
  final WidgetBuilder builder;
  const _ReadingLevel({
    required this.n,
    required this.title,
    required this.desc,
    required this.emoji,
    required this.color,
    required this.builder,
  });
}

class _ReadingLevelCard extends StatefulWidget {
  final _ReadingLevel level;
  final Duration delay;
  const _ReadingLevelCard({required this.level, required this.delay});

  @override
  State<_ReadingLevelCard> createState() => _ReadingLevelCardState();
}

class _ReadingLevelCardState extends State<_ReadingLevelCard>
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
    final lv = widget.level;
    return AnimatedBuilder(
      animation: _enter,
      builder: (_, child) {
        final t = Curves.easeOut.transform(_enter.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, 10 * (1 - t)), child: child),
        );
      },
      child: ListenableBuilder(
        listenable: ProgressStore.instance,
        builder: (context, _) {
          final collected = ProgressStore.instance
              .starsForModuleLevel(Module.reading, lv.n);
          return Material(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                SpeechService.instance.speak(lv.title);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: lv.builder),
                );
              },
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: cardShadow,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: lv.color,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(lv.emoji, style: const TextStyle(fontSize: 30)),
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
                              Flexible(
                                child: Text(
                                  lv.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '· Poziom ${lv.n}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppColors.inkSoft,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lv.desc,
                            style: const TextStyle(
                              color: AppColors.inkSoft,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (collected > 0) ...[
                      const StarIcon(filled: true, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '$collected',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
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
