import 'package:flutter/material.dart';

import '../data/alphabet.dart';
import '../data/module.dart';
import '../data/training.dart';
import '../state/letter_sound.dart';
import '../state/progress_store.dart';
import '../theme.dart';
import '../widgets/paper_background.dart';
import '../widgets/star.dart';
import 'level_select_screen.dart';
import 'report_screen.dart';
import 'training_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Module _module = Module.training;

  void _setModule(Module m) {
    if (m == _module) return;
    setState(() => _module = m);
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: [
                  _TopBar(module: _module),
                  const SizedBox(height: 10),
                  _ModuleSwitch(
                    selected: _module,
                    onSelect: _setModule,
                  ),
                  const SizedBox(height: 10),
                  if (_module == Module.letters) const _Legend(),
                  if (_module == Module.letters) const SizedBox(height: 12),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: ProgressStore.instance,
                      builder: (context, _) => _Grid(module: _module),
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
  final Module module;
  const _TopBar({required this.module});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Wybierz ${module.accusativeSingular}',
              style: const TextStyle(
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
            return GestureDetector(
              onLongPress: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReportScreen()),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ModuleSwitch extends StatelessWidget {
  final Module selected;
  final ValueChanged<Module> onSelect;

  const _ModuleSwitch({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final m in Module.values)
            _ModuleChip(
              label: m.titleLabel,
              icon: switch (m) {
                Module.letters => Icons.abc,
                Module.numbers => Icons.pin,
                Module.training => Icons.gesture,
              },
              active: selected == m,
              onTap: () => onSelect(m),
            ),
        ],
      ),
    );
  }
}

class _ModuleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ModuleChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.accent : AppColors.cardBg;
    final fg = active ? Colors.white : AppColors.inkSoft;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: fg),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
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
  final Module module;
  const _Grid({required this.module});

  @override
  Widget build(BuildContext context) {
    if (module == Module.training) return const _TrainingGrid();

    final items = module.items;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Aim for tiles around 70px on phones, larger on tablets.
        final target = constraints.maxWidth >= 700 ? 90.0 : 64.0;
        final cols = (constraints.maxWidth / target).floor().clamp(4, 16);
        return GridView.builder(
          key: ValueKey(module),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: items.length,
          itemBuilder: (context, idx) {
            return _LetterTile(
              letter: items[idx],
              module: module,
              delay: Duration(milliseconds: idx * 10),
            );
          },
        );
      },
    );
  }
}

class _TrainingGrid extends StatelessWidget {
  const _TrainingGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = (constraints.maxWidth / 200).floor().clamp(2, 5);
        return GridView.builder(
          key: const ValueKey(Module.training),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: trainingPatterns.length,
          itemBuilder: (context, idx) => _TrainingTile(
            pattern: trainingPatterns[idx],
            delay: Duration(milliseconds: idx * 30),
          ),
        );
      },
    );
  }
}

class _TrainingTile extends StatelessWidget {
  final TrainingPattern pattern;
  final Duration delay;
  const _TrainingTile({required this.pattern, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          LetterSound.instance.playClip('zaczynamy.wav');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => TrainingScreen(pattern: pattern),
          ));
        },
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: cardShadow,
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: TrainingGuidePainter(
                      pattern,
                      rows: 1,
                      strokeWidth: 4,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  pattern.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LetterTile extends StatefulWidget {
  final String letter;
  final Module module;
  final Duration delay;
  const _LetterTile({
    required this.letter,
    required this.module,
    required this.delay,
  });

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
    final isDia = widget.module == Module.letters &&
        polishDiacritics.contains(widget.letter);
    final stars = ProgressStore.instance
        .bestStarsFor(widget.letter, module: widget.module);
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
            LetterSound.instance.play(widget.letter);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LevelSelectScreen(
                letter: widget.letter,
                module: widget.module,
              ),
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
                        fontFamily: 'Elementarz',
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
