import 'package:flutter/foundation.dart';

import '../data/module.dart';

class ProgressStore extends ChangeNotifier {
  static final ProgressStore instance = ProgressStore._();
  ProgressStore._();

  final Map<String, Map<int, int>> _stars = {};

  String _key(Module module, String item) => '${module.id}:$item';

  int starsFor(String item, int level, {Module module = Module.letters}) =>
      _stars[_key(module, item)]?[level] ?? 0;

  int bestStarsFor(String item, {Module module = Module.letters}) {
    final m = _stars[_key(module, item)];
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

  void record(String item, int level, int score,
      {Module module = Module.letters}) {
    final key = _key(module, item);
    final cur = _stars[key]?[level] ?? 0;
    if (score <= cur) return;
    _stars.putIfAbsent(key, () => {})[level] = score;
    notifyListeners();
  }

  void reset() {
    _stars.clear();
    notifyListeners();
  }
}
