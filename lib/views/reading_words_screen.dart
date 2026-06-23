import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

/// Reading level 2 — six word tiles (two rows of three), each an SVG picture
/// with its word below. Tapping a tile opens listen-and-repeat practice.
class ReadingWordsScreen extends StatefulWidget {
  const ReadingWordsScreen({super.key});

  @override
  State<ReadingWordsScreen> createState() => _ReadingWordsScreenState();
}

class _ReadingWordsScreenState extends State<ReadingWordsScreen> {
  static const _perPage = 6;
  int _page = 0;
  ReadingWord? _lastTapped;

  int get _pageCount => (readingWords.length + _perPage - 1) ~/ _perPage;

  List<ReadingWord> get _current {
    final start = _page * _perPage;
    final end = (start + _perPage).clamp(0, readingWords.length);
    return readingWords.sublist(start, end);
  }

  void _next() => setState(() => _page = (_page + 1) % _pageCount);

  void _open(ReadingWord w) {
    _lastTapped = w;
    // The dialog speaks the word itself on open — don't double up here.
    showRepeatPractice(
      context,
      word: w.text,
      display: w.text,
      svgAsset: w.assetPath,
      accent: AppColors.accent3,
      onStar: () => ProgressStore.instance
          .record(w.text, 1, 2, module: Module.reading),
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
                    title: 'Czytam wyrazy',
                    color: AppColors.accent3,
                    onSpeak: () => SpeechService.instance
                        .speak(_lastTapped?.text ?? 'Dotknij wyrazu i powtórz'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: ProgressStore.instance,
                      builder: (context, _) => LayoutBuilder(
                        builder: (context, c) {
                          final wide = c.maxWidth >= 700;
                          final maxW = wide ? 720.0 : double.infinity;
                          return Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxW),
                              child: GridView.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 0.82,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  for (final w in _current)
                                    _WordTile(
                                      word: w,
                                      done: ProgressStore.instance.starsFor(
                                              w.text, 2,
                                              module: Module.reading) >
                                          0,
                                      onTap: () => _open(w),
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
                        color: AppColors.accent3,
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

class _WordTile extends StatelessWidget {
  final ReadingWord word;
  final bool done;
  final VoidCallback onTap;
  const _WordTile({required this.word, required this.done, required this.onTap});

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
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                child: Column(
                  children: [
                    Expanded(
                      child: SvgPicture.asset(word.assetPath,
                          fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        word.text,
                        style: const TextStyle(
                          fontFamily: 'Elementarz',
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          height: 1,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
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
