/// Data for the reading module (moduł czytania).
///
/// Level 1 drills *open syllables* (sylaby otwarte) — a consonant followed by a
/// vowel — which is how Polish reading primers (elementarze) introduce reading.
/// Levels 2 and 3 use short, picturable words, each backed by an SVG drawing in
/// `assets/reading_svg/`.
library;

// --- Level 1: syllables -----------------------------------------------------

/// Oral vowels that pair cleanly with single-letter consonants, including the
/// softening "i" (ci, si, ni…).
const _vowels = ['a', 'o', 'u', 'e', 'i', 'y'];

/// Vowels used with digraph consonants (cz, sz, rz…) and "j", which do not form
/// "…i" syllables in Polish.
const _hardVowels = ['a', 'o', 'u', 'e', 'y'];

/// Single-letter consonants that build the core open-syllable grid.
const _consonants = [
  'b', 'c', 'd', 'f', 'g', 'h', 'k', 'l', 'ł', 'm',
  'n', 'p', 'r', 's', 't', 'w', 'z',
];

/// Consonants that only take the "hard" vowels: "j" plus the digraphs (each a
/// single Polish sound written with two letters).
const _hardConsonants = ['j', 'ch', 'cz', 'dz', 'dż', 'rz', 'sz'];

/// Every level-1 syllable, lowercase. The grid renders them uppercase (MA, MO…)
/// to match the concept design and early-reader primers.
final List<String> readingSyllables = [
  for (final c in _consonants)
    for (final v in _vowels) '$c$v',
  for (final c in _hardConsonants)
    for (final v in _hardVowels) '$c$v',
];

// --- Levels 2 & 3: words ----------------------------------------------------

/// A picturable word: its Polish spelling (used for display and text-to-speech)
/// and the SVG illustration that represents it.
class ReadingWord {
  /// Polish word with diacritics, e.g. `samochód`. Spoken verbatim by the TTS
  /// engine and shown uppercased in the UI.
  final String text;

  /// File name (ASCII, no diacritics) under `assets/reading_svg/`.
  final String asset;

  const ReadingWord({required this.text, required this.asset});

  /// Uppercase spelling for on-screen tiles, e.g. `SAMOCHÓD`.
  String get upper => text.toUpperCase();

  /// Full asset path for `SvgPicture.asset`.
  String get assetPath => 'assets/reading_svg/$asset';
}

/// The 12 words available in the reading module. Order is stable so progress
/// keyed by [ReadingWord.text] stays consistent.
const List<ReadingWord> readingWords = [
  ReadingWord(text: 'kot', asset: 'kot.svg'),
  ReadingWord(text: 'pies', asset: 'pies.svg'),
  ReadingWord(text: 'las', asset: 'las.svg'),
  ReadingWord(text: 'samochód', asset: 'samochod.svg'),
  ReadingWord(text: 'mama', asset: 'mama.svg'),
  ReadingWord(text: 'tata', asset: 'tata.svg'),
  ReadingWord(text: 'dłoń', asset: 'dlon.svg'),
  ReadingWord(text: 'nos', asset: 'nos.svg'),
  ReadingWord(text: 'oko', asset: 'oko.svg'),
  ReadingWord(text: 'ołówek', asset: 'olowek.svg'),
  ReadingWord(text: 'telefon', asset: 'telefon.svg'),
  ReadingWord(text: 'szklanka', asset: 'szklanka.svg'),
];
