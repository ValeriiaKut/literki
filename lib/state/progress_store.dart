import 'package:flutter/foundation.dart';

class ProgressStore extends ChangeNotifier {
  static final ProgressStore instance = ProgressStore._();
  ProgressStore._();

  final Map<String, Map<int, int>> _stars = {};

  int starsFor(String letter, int level) => _stars[letter]?[level] ?? 0;

  int bestStarsFor(String letter) {
    final m = _stars[letter];
    if (m == null) return 0;
    return m.values.fold(0, (max, v) => v > max ? v : max);
  }

  int get totalStars {
    int t = 0;
    for (final levels in _stars.values) {
      for (final v in levels.values) {
        t += v;
      }
    }
    return t;
  }

  void record(String letter, int level, int score) {
    final cur = _stars[letter]?[level] ?? 0;
    if (score <= cur) return;
    _stars.putIfAbsent(letter, () => {})[level] = score;
    notifyListeners();
  }

  void reset() {
    _stars.clear();
    notifyListeners();
  }
}
