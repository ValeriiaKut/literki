import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../data/alphabet.dart';
import '../state/progress_store.dart';
import '../theme.dart';
import '../widgets/big_button.dart';
import '../widgets/mascot.dart';
import '../widgets/paper_background.dart';
import 'painter.dart';
import 'success_dialog.dart';

class DrawScreen extends StatefulWidget {
  final String letter;
  final int level;

  const DrawScreen({
    super.key,
    required this.letter,
    required this.level,
  });

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen>
    with SingleTickerProviderStateMixin {
  static const double _targetFontSize = 380;
  static const double _targetLetterSpacing = 2;
  static const double _scoringStrokeWidth = 25;

  List<Offset?> points = [];
  Size? _canvasSize;
  late final AnimationController _demo;
  bool _demoActive = false;

  bool get _isDia => polishDiacritics.contains(widget.letter);

  int get _idx => polishAlphabet.indexOf(widget.letter);
  bool get _hasNext => _idx >= 0 && _idx < polishAlphabet.length - 1;
  bool get _hasPrev => _idx > 0;

  @override
  void initState() {
    super.initState();
    _demo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
  }

  @override
  void dispose() {
    _demo.dispose();
    super.dispose();
  }

  void _goToLetter(int newIndex) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => DrawScreen(
        letter: polishAlphabet[newIndex],
        level: widget.level,
      ),
    ));
  }

  Future<void> _check() async {
    final size = _canvasSize;
    if (size == null) return;

    final hasDrawing = points.any((p) => p != null);
    final score = hasDrawing ? await _scoreDrawing(size) : 0;
    if (score > 0) {
      ProgressStore.instance.record(widget.letter, widget.level, score);
    }
    if (!mounted) return;
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) => SuccessDialog(
        score: score,
        letter: widget.letter,
        isDiacritic: _isDia,
        hasNext: _hasNext,
        onRetry: () {
          Navigator.of(ctx).pop();
          setState(() => points.clear());
        },
        onNext: () {
          Navigator.of(ctx).pop();
          if (_hasNext) _goToLetter(_idx + 1);
        },
      ),
    );
  }

  void _runDemo() {
    setState(() {
      points.clear();
      _demoActive = true;
    });
    _demo.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _demoActive = false);
    });
  }

  Future<int> _scoreDrawing(Size size) async {
    final width = size.width.toInt();
    final height = size.height.toInt();
    if (width <= 0 || height <= 0) return 1;

    final targetImage = await _renderTarget(size);
    final drawingImage = await _renderDrawing(size);

    final targetBytes =
        await targetImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    final drawingBytes =
        await drawingImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    targetImage.dispose();
    drawingImage.dispose();

    if (targetBytes == null || drawingBytes == null) return 1;

    int targetPixels = 0;
    int drawnPixels = 0;
    int intersection = 0;
    final length = targetBytes.lengthInBytes;
    for (int i = 3; i < length; i += 4) {
      final tActive = targetBytes.getUint8(i) > 30;
      final dActive = drawingBytes.getUint8(i) > 30;
      if (tActive) targetPixels++;
      if (dActive) drawnPixels++;
      if (tActive && dActive) intersection++;
    }

    if (targetPixels == 0 || drawnPixels == 0) return 1;

    final coverage = intersection / targetPixels;
    final accuracy = intersection / drawnPixels;
    final denom = coverage + accuracy;
    final f1 = denom == 0 ? 0.0 : 2 * coverage * accuracy / denom;

    if (f1 >= 0.65) return 5;
    if (f1 >= 0.50) return 4;
    if (f1 >= 0.35) return 3;
    if (f1 >= 0.20) return 2;
    return 1;
  }

  Future<ui.Image> _renderTarget(Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final tp = TextPainter(
      text: TextSpan(
        text: widget.letter,
        style: const TextStyle(
          fontFamily: 'Handwriting',
          fontSize: _targetFontSize,
          fontWeight: FontWeight.w800,
          color: Colors.black,
          letterSpacing: _targetLetterSpacing,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
    );
    return recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
  }

  Future<ui.Image> _renderDrawing(Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = _scoringStrokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (int i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      if (a != null && b != null) {
        canvas.drawLine(a, b, paint);
      }
    }
    return recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const PaperBackground(variant: PaperVariant.lines),
          SafeArea(
            child: LayoutBuilder(builder: (context, c) {
              final wide = c.maxWidth >= 700;
              return Column(
                children: [
                  _topBar(wide),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: wide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: _canvasCard(wide: true)),
                                const SizedBox(width: 20),
                                _sideHelper(compact: false),
                              ],
                            )
                          : Column(
                              children: [
                                Expanded(child: _canvasCard(wide: false)),
                                const SizedBox(height: 8),
                                _sideHelper(compact: true),
                              ],
                            ),
                    ),
                  ),
                  _bottomBar(wide),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _topBar(bool wide) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _RoundButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 10),
          if (wide) ...[
            const Text(
              'Litera',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.inkSoft,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            widget.letter,
            style: TextStyle(
              fontFamily: 'Handwriting',
              fontSize: wide ? 44 : 36,
              fontWeight: FontWeight.w800,
              height: 1,
              color: _isDia ? AppColors.diacritic : AppColors.ink,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'P${widget.level}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          if (wide) ...[
            _PillButton(
              icon: Icons.visibility_rounded,
              label: 'Pokaż',
              onTap: _runDemo,
            ),
            const SizedBox(width: 8),
            _PillButton(
              icon: Icons.cleaning_services_rounded,
              label: 'Wyczyść',
              onTap: () => setState(() => points.clear()),
            ),
          ] else ...[
            _RoundButton(
              icon: Icons.visibility_rounded,
              onTap: _runDemo,
            ),
            const SizedBox(width: 8),
            _RoundButton(
              icon: Icons.cleaning_services_rounded,
              onTap: () => setState(() => points.clear()),
            ),
          ],
        ],
      ),
    );
  }

  Widget _canvasCard({required bool wide}) {
    final card = Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(builder: (context, constraints) {
        _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          children: [
            _guideForLevel(),
            if (_demoActive) _demoOverlay(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) =>
                  setState(() => points.add(d.localPosition)),
              onPanUpdate: (d) =>
                  setState(() => points.add(d.localPosition)),
              onPanEnd: (_) => points.add(null),
              child: CustomPaint(
                painter: DrawingPainter(
                  points,
                  color: _isDia ? AppColors.diacritic : AppColors.ink,
                  strokeWidth: 12,
                ),
                size: Size.infinite,
              ),
            ),
            if (widget.level == 1)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent2,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '① zacznij tutaj',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
    if (wide) {
      return AspectRatio(aspectRatio: 760 / 540, child: card);
    }
    return card;
  }

  Widget _guideForLevel() {
    if (widget.level == 1) {
      return Center(
        child: Text(
          widget.letter,
          style: TextStyle(
            fontFamily: 'Handwriting',
            fontSize: _targetFontSize,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: _targetLetterSpacing,
            color: _isDia
                ? AppColors.diacritic.withValues(alpha: 0.28)
                : AppColors.guideInk,
          ),
        ),
      );
    }
    if (widget.level == 2) {
      return Center(
        child: Text(
          widget.letter,
          style: TextStyle(
            fontFamily: 'Handwriting',
            fontSize: _targetFontSize,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: _targetLetterSpacing,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..strokeJoin = StrokeJoin.round
              ..color = (_isDia ? AppColors.diacritic : AppColors.inkSoft)
                  .withValues(alpha: 0.55),
          ),
        ),
      );
    }
    return Center(
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: AppColors.inkSoft.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _demoOverlay() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _demo,
        builder: (context, _) {
          final t = _demo.value;
          return Stack(
            children: [
              Center(
                child: ClipRect(
                  clipper: _RevealClipper(t),
                  child: Text(
                    widget.letter,
                    style: TextStyle(
                      fontFamily: 'Handwriting',
                      fontSize: _targetFontSize,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: _targetLetterSpacing,
                      color: _isDia ? AppColors.diacritic : AppColors.ink,
                    ),
                  ),
                ),
              ),
              LayoutBuilder(builder: (_, c) {
                final x = c.maxWidth * (0.08 + 0.84 * t);
                return Positioned(
                  left: x - 14,
                  top: c.maxHeight / 2 - 14,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.accent3,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent3.withValues(alpha: 0.7),
                          blurRadius: 24,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _sideHelper({required bool compact}) {
    final mood = points.where((p) => p != null).length > 2
        ? MascotMood.cheer
        : MascotMood.idle;
    final hint = switch (widget.level) {
      1 => 'Pisz powoli po szarej literze.',
      2 => 'Pisz wewnątrz obrysu.',
      _ => 'Spróbuj sam(a)! Dasz radę!',
    };
    final hintBubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardShadow,
      ),
      child: Text(
        hint,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 14,
          height: 1.3,
        ),
      ),
    );
    if (compact) {
      return Row(
        children: [
          Mascot(size: 64, mood: mood),
          const SizedBox(width: 12),
          Expanded(child: hintBubble),
        ],
      );
    }
    return SizedBox(
      width: 160,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Mascot(size: 130, mood: mood),
          const SizedBox(height: 14),
          hintBubble,
        ],
      ),
    );
  }

  Widget _bottomBar(bool wide) {
    final sprawdz = BigButton(
      size: BigButtonSize.lg,
      color: AppColors.success,
      onPressed: _check,
      icon: const Icon(Icons.check, color: Colors.white, size: 26),
      child: const Text('Sprawdź'),
    );
    if (wide) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: _hasPrev,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: BigButton(
                size: BigButtonSize.md,
                color: AppColors.cardBg,
                textColor: AppColors.ink,
                onPressed: () => _goToLetter(_idx - 1),
                icon: const Icon(Icons.arrow_back,
                    color: AppColors.ink, size: 20),
                child: const Text('Poprzednia'),
              ),
            ),
            sprawdz,
            Visibility(
              visible: _hasNext,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: BigButton(
                size: BigButtonSize.md,
                color: AppColors.cardBg,
                textColor: AppColors.ink,
                onPressed: () => _goToLetter(_idx + 1),
                child: const Text('Następna →'),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RoundButton(
            icon: Icons.arrow_back,
            onTap: _hasPrev ? () => _goToLetter(_idx - 1) : () {},
          ),
          sprawdz,
          _RoundButton(
            icon: Icons.arrow_forward,
            onTap: _hasNext ? () => _goToLetter(_idx + 1) : () {},
          ),
        ],
      ),
    );
  }
}

class _RevealClipper extends CustomClipper<Rect> {
  final double t;
  _RevealClipper(this.t);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * t, size.height);

  @override
  bool shouldReclip(covariant _RevealClipper old) => old.t != t;
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
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: cardShadow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.ink, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
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
