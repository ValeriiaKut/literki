import 'package:flutter/material.dart';

import '../data/alphabet.dart';
import '../state/progress_store.dart';
import '../theme.dart';
import '../widgets/paper_background.dart';
import '../widgets/star.dart';
import 'level_select_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const PaperBackground(variant: PaperVariant.dots),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: [
                  _TopBar(),
                  const SizedBox(height: 8),
                  const _Legend(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: ProgressStore.instance,
                      builder: (context, _) => const _Grid(),
                    ),
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

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.of(context).maybePop(),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Wybierz literę',
              style: TextStyle(
                fontFamily: 'Handwriting',
                fontWeight: FontWeight.w700,
                fontSize: 36,
                color: AppColors.ink,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        ListenableBuilder(
          listenable: ProgressStore.instance,
          builder: (context, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: cardShadow,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StarIcon(filled: true, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    '${ProgressStore.instance.totalStars}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        spacing: 18,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.diacritic,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 6),
              const Text('Polskie znaki',
                  style:
                      TextStyle(color: AppColors.inkSoft, fontSize: 14)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              StarIcon(filled: true, size: 14),
              SizedBox(width: 6),
              Text('Twoje gwiazdki',
                  style:
                      TextStyle(color: AppColors.inkSoft, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Aim for tiles around 70px on phones, larger on tablets.
        final target = constraints.maxWidth >= 700 ? 90.0 : 64.0;
        final cols = (constraints.maxWidth / target).floor().clamp(4, 16);
        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: polishAlphabet.length,
          itemBuilder: (context, idx) {
            return _LetterTile(
              letter: polishAlphabet[idx],
              delay: Duration(milliseconds: idx * 10),
            );
          },
        );
      },
    );
  }
}

class _LetterTile extends StatefulWidget {
  final String letter;
  final Duration delay;
  const _LetterTile({required this.letter, required this.delay});

  @override
  State<_LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<_LetterTile>
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
    final isDia = polishDiacritics.contains(widget.letter);
    final stars = ProgressStore.instance.bestStarsFor(widget.letter);
    return AnimatedBuilder(
      animation: _enter,
      builder: (_, child) {
        final t = Curves.easeOut.transform(_enter.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - t)),
            child: Transform.scale(scale: 0.94 + 0.06 * t, child: child),
          ),
        );
      },
      child: Material(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LevelSelectScreen(letter: widget.letter),
            ));
          },
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: cardShadow,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 14),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.letter,
                      style: TextStyle(
                        fontFamily: 'Handwriting',
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        height: 1,
                        color: isDia ? AppColors.diacritic : AppColors.ink,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 4,
                  right: 4,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomCenter,
                    child: StarRow(count: stars, size: 7, gap: 1),
                  ),
                ),
              ],
            ),
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
