import 'alphabet.dart';
import 'numbers.dart';
import 'training.dart';

enum Module {
  training,
  letters,
  numbers;

  String get id => name;

  String get titleLabel => switch (this) {
        Module.letters => 'Litery',
        Module.numbers => 'Cyfry',
        Module.training => 'Trening',
      };

  String get singularLabel => switch (this) {
        Module.letters => 'litera',
        Module.numbers => 'cyfra',
        Module.training => 'ćwiczenie',
      };

  String get accusativeSingular => switch (this) {
        Module.letters => 'literę',
        Module.numbers => 'cyfrę',
        Module.training => 'ćwiczenie',
      };

  String get genitiveSingular => switch (this) {
        Module.letters => 'litery',
        Module.numbers => 'cyfry',
        Module.training => 'ćwiczenia',
      };

  List<String> get items => switch (this) {
        Module.letters => polishAlphabet,
        Module.numbers => digits,
        Module.training => [for (final p in trainingPatterns) p.id],
      };

  static Module fromId(String id) =>
      Module.values.firstWhere((m) => m.id == id, orElse: () => Module.letters);
}
