import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../state/speech_service.dart';
import '../theme.dart';
import '../widgets/big_button.dart';
import '../widgets/mascot.dart';
import '../widgets/reading_widgets.dart';

/// Listen-and-repeat practice for a single syllable or word.
///
/// The child hears the prompt (TTS), repeats it into the mic, and the speech
/// recognizer checks — leniently — whether they said it. Success is celebrated
/// and [onStar] fires once; a miss is met only with gentle encouragement and an
/// unlimited retry. If recognition is unavailable, the child can still mark the
/// prompt as read to collect the star (never a dead end).
Future<void> showRepeatPractice(
  BuildContext context, {
  required String word,
  required String display,
  String? svgAsset,
  required Color accent,
  required VoidCallback onStar,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0x73140F0A),
    builder: (_) => _RepeatPracticeDialog(
      word: word,
      display: display,
      svgAsset: svgAsset,
      accent: accent,
      onStar: onStar,
    ),
  );
}

enum _Phase { idle, listening, success, retry, unavailable }

class _RepeatPracticeDialog extends StatefulWidget {
  final String word;
  final String display;
  final String? svgAsset;
  final Color accent;
  final VoidCallback onStar;

  const _RepeatPracticeDialog({
    required this.word,
    required this.display,
    required this.svgAsset,
    required this.accent,
    required this.onStar,
  });

  @override
  State<_RepeatPracticeDialog> createState() => _RepeatPracticeDialogState();
}

class _RepeatPracticeDialogState extends State<_RepeatPracticeDialog> {
  _Phase _phase = _Phase.idle;
  String _heard = '';
  bool _starGiven = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SpeechService.instance.speak(widget.word);
    });
  }

  @override
  void dispose() {
    SpeechService.instance.cancelListening();
    super.dispose();
  }

  void _speak() => SpeechService.instance.speak(widget.word);

  Future<void> _toggleMic() async {
    if (_phase == _Phase.listening) {
      await SpeechService.instance.stopListening();
      if (mounted && _phase == _Phase.listening) {
        setState(() => _phase = _Phase.idle);
      }
      return;
    }
    setState(() {
      _phase = _Phase.listening;
      _heard = '';
    });
    final started = await SpeechService.instance.startListening(
      onResult: _onResult,
    );
    if (!started && mounted) {
      setState(() => _phase = _Phase.unavailable);
    }
  }

  void _onResult(String words, bool isFinal) {
    if (!mounted || _phase == _Phase.success) return;
    setState(() => _heard = words);
    if (SpeechService.matches(widget.word, words)) {
      _succeed();
    } else if (isFinal) {
      setState(() => _phase = _Phase.retry);
    }
  }

  void _succeed() {
    SpeechService.instance.stopListening();
    if (!_starGiven) {
      _starGiven = true;
      widget.onStar();
    }
    setState(() => _phase = _Phase.success);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 460,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          padding: const EdgeInsets.fromLTRB(28, 22, 28, 24),
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
          child: _phase == _Phase.success
              ? _buildSuccess()
              : _buildPractice(),
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ReadingCelebration(message: 'Brawo!', mood: MascotMood.wow),
        const SizedBox(height: 18),
        BigButton(
          size: BigButtonSize.md,
          color: AppColors.success,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Dalej →'),
        ),
      ],
    );
  }

  Widget _buildPractice() {
    final instruction = switch (_phase) {
      _Phase.listening => 'Słucham… powiedz na głos!',
      _Phase.retry => 'Prawie! Posłuchaj i spróbuj jeszcze raz 🙂',
      _Phase.unavailable =>
        'Przeczytaj na głos, a potem naciśnij „Umiem”.',
      _ => 'Posłuchaj i powtórz na głos.',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: ReadingRoundButton(
            icon: Icons.close,
            color: AppColors.bgSoft,
            iconColor: AppColors.inkSoft,
            size: 40,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        if (widget.svgAsset != null) ...[
          SvgPicture.asset(widget.svgAsset!, height: 120),
          const SizedBox(height: 12),
        ],
        Text(
          widget.display,
          style: TextStyle(
            fontFamily: 'Elementarz',
            fontWeight: FontWeight.w800,
            fontSize: 64,
            height: 1,
            color: widget.accent,
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _speak,
          icon: Icon(Icons.volume_up_rounded, color: widget.accent),
          label: Text(
            'Słuchaj jeszcze raz',
            style: TextStyle(color: widget.accent, fontSize: 16),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          instruction,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17, color: AppColors.inkSoft),
        ),
        const SizedBox(height: 18),
        if (_phase == _Phase.unavailable)
          BigButton(
            size: BigButtonSize.md,
            color: AppColors.success,
            onPressed: _succeed,
            child: const Text('Umiem! ⭐'),
          )
        else
          MicButton(
            listening: _phase == _Phase.listening,
            color: widget.accent,
            onTap: _toggleMic,
          ),
        if (_heard.isNotEmpty && _phase != _Phase.unavailable) ...[
          const SizedBox(height: 12),
          Text(
            'Słyszę: „$_heard”',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.inkSoft),
          ),
        ],
      ],
    );
  }
}
