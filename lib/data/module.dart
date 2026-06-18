import 'alphabet.dart';
import 'numbers.dart';
import 'training.dart';

enum Module {
  training,
  reading,
  letters,
  numbers;

  String get id => name;

  String get titleLabel => switch (this) {
        Module.letters => 'Litery',
        Module.numbers => 'Cyfry',
        Module.training => 'Trening',
        Module.reading => 'Czytanie',
      };

  String get singularLabel => switch (this) {
        Module.letters => 'litera',
        Module.numbers => 'cyfra',
        Module.training => 'ćwiczenie',
        Module.reading => 'czytanie',
      };

  String get accusativeSingular => switch (this) {
        Module.letters => 'literę',
        Module.numbers => 'cyfrę',
        Module.training => 'ćwiczenie',
        Module.reading => 'czytanie',
      };

  String get genitiveSingular => switch (this) {
        Module.letters => 'litery',
        Module.numbers => 'cyfry',
        Module.training => 'ćwiczenia',
        Module.reading => 'czytania',
      };

  List<String> get items => switch (this) {
        Module.letters => polishAlphabet,
        Module.numbers => digits,
        Module.training => [for (final p in trainingPatterns) p.id],
        Module.reading => const [],
      };

  static Module fromId(String id) =>
      Module.values.firstWhere((m) => m.id == id, orElse: () => Module.letters);
}
