import 'package:flutter/material.dart';

import '../data/training.dart';
import '../state/letter_sound.dart';
import '../theme.dart';
import '../widgets/big_button.dart';
import '../widgets/mascot.dart';
import '../widgets/paper_background.dart';
import 'painter.dart';

/// A free-practice ("Trening") canvas: the child traces a repeating
/// pre-writing pattern to warm up the hand. There is no scoring — finishing
/// always gives positive feedback.
class TrainingScreen extends StatefulWidget {
  final TrainingPattern pattern;

  const TrainingScreen({super.key, required this.pattern});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final List<Offset?> _points = [];

  @override
  void initState() {
    super.initState();
    LetterSound.instance.playClip('zaczynamy.wav');
  }

  void _clear() => setState(_points.clear);

  void _finish() {
    LetterSound.instance.playClip('brawo.wav');
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) => _PraiseDialog(
        onAgain: () {
          Navigator.of(ctx).pop();
          _clear();
        },
        onDone: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).maybePop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const PaperBackground(variant: PaperVariant.lines),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(),
                  const SizedBox(height: 12),
                  Expanded(child: _canvasCard()),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _PillButton(
                        icon: Icons.cleaning_services_rounded,
                        label: 'Wyczyść',
                        onTap: _clear,
                      ),
                      const Spacer(),
                      BigButton(
                        size: BigButtonSize.md,
                        color: AppColors.success,
                        onPressed: _finish,
                        child: const Text('Gotowe'),
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

  Widget _header() {
    return Row(
      children: [
        _RoundButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.pattern.label,
                style: const TextStyle(
                  fontSize: 24,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                widget.pattern.hint,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.inkSoft,
                ),
              ),
            ],
          ),
        ),
        const Mascot(size: 64, mood: MascotMood.cheer),
      ],
    );
  }

  Widget _canvasCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const rows = 2;
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: TrainingGuidePainter(
                    widget.pattern,
                    rows: rows,
                    strokeWidth: 7,
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (d) =>
                    setState(() => _points.add(d.localPosition)),
                onPanUpdate: (d) =>
                    setState(() => _points.add(d.localPosition)),
                onPanEnd: (_) => _points.add(null),
                child: CustomPaint(
                  painter: DrawingPainter(
                    _points,
                    color: AppColors.ink,
                    strokeWidth: 12,
                  ),
                  size: Size.infinite,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PraiseDialog extends StatelessWidget {
  final VoidCallback onAgain;
  final VoidCallback onDone;

  const _PraiseDialog({required this.onAgain, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: const Color(0x73140F0A),
        alignment: Alignment.center,
        child: Container(
          width: 420,
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
              const Positioned(
                top: -90,
                child: Mascot(size: 150, mood: MascotMood.wow),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Brawo! 🎉',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ręka rozgrzana!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.inkSoft,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                        onPressed: onAgain,
                        child: const Text('Jeszcze raz'),
                      ),
                      BigButton(
                        size: BigButtonSize.md,
                        color: AppColors.success,
                        onPressed: onDone,
                        child: const Text('Gotowe'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: cardShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.ink, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
