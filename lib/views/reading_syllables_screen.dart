import 'package:flutter/material.dart';

import '../data/module.dart';
import '../data/reading.dart';
import '../state/progress_store.dart';
import '../state/speech_service.dart';
import '../theme.dart';
import '../widgets/big_button.dart';
import '../widgets/paper_background.dart';
import '../widgets/reading_widgets.dart';
import '../widgets/star.dart';
import 'repeat_practice_dialog.dart';

/// Reading level 1 — a 3×3 grid of syllables with a "Następne" button to page
/// through the full set. Tapping a syllable opens listen-and-repeat practice.
class ReadingSyllablesScreen extends StatefulWidget {
  const ReadingSyllablesScreen({super.key});

  @override
  State<ReadingSyllablesScreen> createState() => _ReadingSyllablesScreenState();
}

class _ReadingSyllablesScreenState extends State<ReadingSyllablesScreen> {
  static const _perPage = 9;
  int _page = 0;
  String? _lastTapped;

  int get _pageCount => (readingSyllables.length + _perPage - 1) ~/ _perPage;

  List<String> get _current {
    final start = _page * _perPage;
    final end = (start + _perPage).clamp(0, readingSyllables.length);
    return readingSyllables.sublist(start, end);
  }

  void _next() {
    setState(() => _page = (_page + 1) % _pageCount);
  }

  void _open(String syllable) {
    _lastTapped = syllable;
    // The dialog speaks the syllable itself on open — don't double up here.
    showRepeatPractice(
      context,
      word: syllable,
      display: syllable.toUpperCase(),
      accent: AppColors.accent,
      onStar: () => ProgressStore.instance
          .record(syllable, 1, 1, module: Module.reading),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const PaperBackground(variant: PaperVariant.dots),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                children: [
                  ReadingTopBar(
                    title: 'Czytam sylaby',
                    color: AppColors.accent,
                    onSpeak: () => SpeechService.instance
                        .speak(_lastTapped ?? 'Dotknij sylaby i powtórz'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: ProgressStore.instance,
                      builder: (context, _) => LayoutBuilder(
                        builder: (context, c) {
                          final maxW = c.maxWidth >= 700 ? 560.0 : double.infinity;
                          return Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxW),
                              child: GridView.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  for (final s in _current)
                                    _SyllableTile(
                                      syllable: s,
                                      done: ProgressStore.instance.starsFor(
                                              s, 1, module: Module.reading) >
                                          0,
                                      onTap: () => _open(s),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Strona ${_page + 1} / $_pageCount',
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      BigButton(
                        size: BigButtonSize.md,
                        onPressed: _next,
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 20),
                        child: const Text('Następne'),
                      ),
                    ],
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

class _SyllableTile extends StatelessWidget {
  final String syllable;
  final bool done;
  final VoidCallback onTap;
  const _SyllableTile({
    required this.syllable,
    required this.done,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: cardShadow,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    syllable.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Elementarz',
                      fontWeight: FontWeight.w800,
                      fontSize: 52,
                      height: 1,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
              if (done)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: StarIcon(filled: true, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
