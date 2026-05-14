import 'package:flutter/material.dart';

import '../data/module.dart';
import '../services/data_logger.dart';
import '../theme.dart';
import '../widgets/big_button.dart';
import '../widgets/paper_background.dart';
import '../widgets/star.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<SessionEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await DataLogger.loadEntries();
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Wyczyścić raport?'),
        content: const Text(
          'Wszystkie zapisane próby zostaną usunięte. Tej operacji nie można cofnąć.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Wyczyść',
              style: TextStyle(color: AppColors.diacritic),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await DataLogger.clear();
    await _load();
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
                      const Expanded(
                        child: Text(
                          'Raport pedagogiczny',
                          style: TextStyle(
                            fontSize: 22,
                            color: AppColors.ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (_entries.isNotEmpty)
                        BigButton(
                          size: BigButtonSize.sm,
                          color: AppColors.cardBg,
                          textColor: AppColors.diacritic,
                          onPressed: _confirmClear,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.diacritic,
                            size: 18,
                          ),
                          child: const Text('Wyczyść'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _body()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_entries.isEmpty) {
      return const _EmptyState();
    }
    final stats = _computeStats(_entries);
    final sorted = stats.values.toList()
      ..sort((a, b) {
        final c = a.avgScore.compareTo(b.avgScore);
        if (c != 0) return c;
        return a.item.compareTo(b.item);
      });
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _SummaryCard(entries: _entries),
        const SizedBox(height: 16),
        const Text(
          'Wyniki według elementu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        ...sorted.map((s) => _StatCard(stats: s)),
      ],
    );
  }

  Map<String, _ElementStats> _computeStats(List<SessionEntry> entries) {
    final map = <String, _ElementStats>{};
    for (final e in entries) {
      final key = '${e.module.id}:${e.item}';
      map.putIfAbsent(key, () => _ElementStats(e.module, e.item)).add(e);
    }
    return map;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: cardShadow,
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded,
                color: AppColors.inkSoft, size: 48),
            SizedBox(height: 12),
            Text(
              'Brak danych',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Dzieci nie wykonały jeszcze\nżadnego zadania.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.inkSoft),
            ),
          ],
        ),
      ),
    );
  }
}

class _ElementStats {
  final Module module;
  final String item;
  int attempts = 0;
  int totalDuration = 0;
  int sumScore = 0;
  int bestScore = 0;

  _ElementStats(this.module, this.item);

  void add(SessionEntry e) {
    attempts++;
    totalDuration += e.durationSeconds;
    sumScore += e.score;
    if (e.score > bestScore) bestScore = e.score;
  }

  double get avgScore => attempts == 0 ? 0 : sumScore / attempts;
  double get avgDuration => attempts == 0 ? 0 : totalDuration / attempts;
}

class _SummaryCard extends StatelessWidget {
  final List<SessionEntry> entries;

  const _SummaryCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final total = entries.length;
    final unique = entries
        .map((e) => '${e.module.id}:${e.item}')
        .toSet()
        .length;
    final avg = entries.isEmpty
        ? 0.0
        : entries.map((e) => e.score).reduce((a, b) => a + b) / entries.length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'Prób łącznie', value: '$total'),
          _Stat(label: 'Elementów', value: '$unique'),
          _Stat(
            label: 'Śr. wynik',
            value: avg.toStringAsFixed(1),
            trailing: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: StarIcon(filled: true, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _Stat({required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            ?trailing,
          ],
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final _ElementStats stats;

  const _StatCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.bgSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              stats.item,
              style: const TextStyle(
                fontFamily: 'Handwriting',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stats.module.titleLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.inkSoft,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Prób: ${stats.attempts}  •  Śr. czas: ${stats.avgDuration.toStringAsFixed(0)}s',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          StarRow(count: stats.avgScore.round(), size: 16, gap: 2),
        ],
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
