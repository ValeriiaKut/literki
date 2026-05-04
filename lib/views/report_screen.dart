import 'package:flutter/material.dart';
import '../services/data_logger.dart';

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
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  Map<String, _ElementStats> _computeStats() {
    final map = <String, _ElementStats>{};
    for (final e in _entries) {
      final key = '${e.modul}:${e.element}';
      map.putIfAbsent(key, () => _ElementStats(e.modul, e.element));
      map[key]!.add(e);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontFamily: 'Roboto'),
      ),
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Raport pedagogiczny'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? const Center(
                  child: Text(
                    'Brak danych.\nDzieci nie wykonały jeszcze żadnego zadania.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : _buildReport(),
      ),
    );
  }

  Widget _buildReport() {
    final stats = _computeStats();
    final sorted = stats.values.toList()
      ..sort((a, b) => a.sredniWynik.compareTo(b.sredniWynik));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SummaryCard(entries: _entries),
        const SizedBox(height: 16),
        const Text(
          'Wyniki według elementu',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...sorted.map((s) => _StatCard(stats: s)),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ElementStats {
  final String modul;
  final String element;
  int totalProb = 0;
  int totalCzas = 0;
  int sumWynik = 0;
  int sesji = 0;

  _ElementStats(this.modul, this.element);

  void add(SessionEntry e) {
    totalProb += e.numerProby;
    totalCzas += e.czasSekundy;
    sumWynik += e.wynik;
    sesji++;
  }

  double get sredniWynik => sesji == 0 ? 0 : sumWynik / sesji;
  double get sredniCzas => sesji == 0 ? 0 : totalCzas / sesji;
}

class _SummaryCard extends StatelessWidget {
  final List<SessionEntry> entries;

  const _SummaryCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final totalSesji = entries.length;
    final unikalne = entries.map((e) => e.element).toSet().length;
    final sredniWynik = entries.isEmpty
        ? 0.0
        : entries.map((e) => e.wynik).reduce((a, b) => a + b) / entries.length;

    return Card(
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Stat(label: 'Prób łącznie', value: '$totalSesji'),
            _Stat(label: 'Elementów', value: '$unikalne'),
            _Stat(
              label: 'Śr. wynik',
              value: '${sredniWynik.toStringAsFixed(1)} ★',
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final _ElementStats stats;

  const _StatCard({required this.stats});

  Color get _color {
    if (stats.sredniWynik >= 4) return const Color(0xFFC8E6C9);
    if (stats.sredniWynik >= 3) return const Color(0xFFFFF9C4);
    return const Color(0xFFFFCDD2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _color,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Text(
          stats.element,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        title: Text(
          stats.modul,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          'Prób: ${stats.totalProb}  •  Śr. czas: ${stats.sredniCzas.toStringAsFixed(0)}s',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (i) => Icon(
              i < stats.sredniWynik.round()
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: Colors.amber,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
