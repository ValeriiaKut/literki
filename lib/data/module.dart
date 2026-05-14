import 'alphabet.dart';
import 'numbers.dart';

enum Module {
  letters,
  numbers;

  String get id => name;

  String get titleLabel => switch (this) {
        Module.letters => 'Litery',
        Module.numbers => 'Cyfry',
      };

  String get singularLabel => switch (this) {
        Module.letters => 'litera',
        Module.numbers => 'cyfra',
      };

  String get accusativeSingular => switch (this) {
        Module.letters => 'literę',
        Module.numbers => 'cyfrę',
      };

  String get genitiveSingular => switch (this) {
        Module.letters => 'litery',
        Module.numbers => 'cyfry',
      };

  List<String> get items => switch (this) {
        Module.letters => polishAlphabet,
        Module.numbers => digits,
      };

  static Module fromId(String id) =>
      Module.values.firstWhere((m) => m.id == id, orElse: () => Module.letters);
}
