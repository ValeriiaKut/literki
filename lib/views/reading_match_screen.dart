import 'dart:math' as math;

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

/// Reading level 3 — "Przeczytaj i wskaż". The child reads (and may repeat) a
/// word, then taps the matching picture among three. A correct pick earns a
/// star; a wrong pick only nudges them to try again (positive reinforcement).
class ReadingMatchScreen extends StatefulWidget {
  const ReadingMatchScreen({super.key});

  @override
  State<ReadingMatchScreen> createState() => _ReadingMatchScreenState();
}

class _ReadingMatchScreenState extends State<ReadingMatchScreen> {
  final math.Random _rng = math.Random();
  late List<ReadingWord> _queue;
  late ReadingWord _target;
  late List<ReadingWord> _options;

  bool _solved = false;
  bool _listening = false;
  bool _saidIt = false;
  String _heard = '';
  ReadingWord? _wrong;

  static const _accent = AppColors.accent2;

  @override
  void initState() {
    super.initState();
    _queue = [...readingWords]..shuffle(_rng);
    _newRound(initial: true);
  }

  @override
  void dispose() {
    SpeechService.instance.cancelListening();
    super.dispose();
  }

  void _newRound({bool initial = false}) {
    if (_queue.isEmpty) {
      _queue = [...readingWords]..shuffle(_rng);
      // Avoid repeating the just-finished word back to back.
      if (!initial && _queue.first == _target && _queue.length > 1) {
        final first = _queue.removeAt(0);
        _queue.add(first);
      }
    }
    final target = _queue.removeAt(0);
    final distractors = readingWords.where((w) => w != target).toList()
      ..shuffle(_rng);
    final options = [target, ...distractors.take(2)]..shuffle(_rng);

    setState(() {
      _target = target;
      _options = options;
      _solved = false;
      _saidIt = false;
      _heard = '';
      _wrong = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SpeechService.instance.speak(target.text);
    });
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      await SpeechService.instance.stopListening();
      if (mounted) setState(() => _listening = false);
      return;
    }
    setState(() {
      _listening = true;
      _heard = '';
    });
    final ok = await SpeechService.instance.startListening(onResult: _onResult);
    if (!ok && mounted) setState(() => _listening = false);
  }

  void _onResult(String words, bool isFinal) {
    if (!mounted) return;
    setState(() => _heard = words);
    if (SpeechService.matches(_target.text, words)) {
      SpeechService.instance.stopListening();
      setState(() {
        _saidIt = true;
        _listening = false;
      });
    } else if (isFinal) {
      setState(() => _listening = false);
    }
  }

  void _pick(ReadingWord w) {
    if (_solved) return;
    if (w == _target) {
      ProgressStore.instance.record(_target.text, 1, 3, module: Module.reading);
      setState(() => _solved = true);
    } else {
      setState(() => _wrong = w);
    }
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
                    title: 'Przeczytaj i wskaż',
                    color: _accent,
                    onSpeak: () => SpeechService.instance.speak(_target.text),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          ),
          if (_solved)
            _SuccessOverlay(
              onNext: _newRound,
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth >= 700;
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: wide ? 820 : 560),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Word card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 22),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: cardShadow,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _target.text,
                      style: TextStyle(
                        fontFamily: 'Elementarz',
                        fontWeight: FontWeight.w800,
                        fontSize: wide ? 96 : 64,
                        height: 1,
                        color: _accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _MicPractice(
                  listening: _listening,
                  saidIt: _saidIt,
                  heard: _heard,
                  onTap: _toggleMic,
                ),
                const SizedBox(height: 18),
                _OptionsRow(
                  options: _options,
                  wrong: _wrong,
                  onPick: _pick,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// The optional "say it" practice line: a mic and a status message.
class _MicPractice extends StatelessWidget {
  final bool listening;
  final bool saidIt;
  final String heard;
  final VoidCallback onTap;
  const _MicPractice({
    required this.listening,
    required this.saidIt,
    required this.heard,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String label;
    if (saidIt) {
      label = 'Świetnie przeczytane! Teraz wskaż obrazek.';
    } else if (listening) {
      label = 'Słucham… przeczytaj na głos!';
    } else {
      label = 'Naciśnij i przeczytaj wyraz na głos.';
    }
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: saidIt
                      ? AppColors.success
                      : (listening ? AppColors.accent2 : AppColors.accent),
                  boxShadow: cardShadow,
                ),
                child: Icon(
                  saidIt
                      ? Icons.check_rounded
                      : (listening
                          ? Icons.graphic_eq_rounded
                          : Icons.mic_rounded),
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.inkSoft,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        if (heard.isNotEmpty && !saidIt) ...[
          const SizedBox(height: 6),
          Text(
            'Słyszę: „$heard”',
            style: const TextStyle(fontSize: 13, color: AppColors.inkSoft),
          ),
        ],
      ],
    );
  }
}

class _OptionsRow extends StatelessWidget {
  final List<ReadingWord> options;
  final ReadingWord? wrong;
  final ValueChanged<ReadingWord> onPick;
  const _OptionsRow({
    required this.options,
    required this.wrong,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final w in options) ...[
          Expanded(
            child: _OptionTile(
              word: w,
              isWrong: wrong == w,
              onTap: () => onPick(w),
            ),
          ),
          if (w != options.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final ReadingWord word;
  final bool isWrong;
  final VoidCallback onTap;
  const _OptionTile({
    required this.word,
    required this.isWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: cardShadow,
              border: Border.all(
                color: isWrong ? AppColors.accent2 : Colors.transparent,
                width: 3,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: SvgPicture.asset(word.assetPath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

class _SuccessOverlay extends StatelessWidget {
  final VoidCallback onNext;
  const _SuccessOverlay({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x73140F0A),
      alignment: Alignment.center,
      child: Container(
        width: 440,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ReadingCelebration(message: 'Brawo! Dobrze!'),
            const SizedBox(height: 18),
            BigButton(
              size: BigButtonSize.md,
              color: AppColors.success,
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 20),
              child: const Text('Następne'),
            ),
          ],
        ),
      ),
    );
  }
}
