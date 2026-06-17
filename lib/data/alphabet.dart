const List<String> polishAlphabet = [
  'A', 'a', 'Ą', 'ą', 'B', 'b', 'C', 'c', 'Ć', 'ć',
  'D', 'd', 'E', 'e', 'Ę', 'ę', 'F', 'f', 'G', 'g',
  'H', 'h', 'I', 'i', 'J', 'j', 'K', 'k', 'L', 'l',
  'Ł', 'ł', 'M', 'm', 'N', 'n', 'Ń', 'ń', 'O', 'o',
  'Ó', 'ó', 'P', 'p', 'R', 'r', 'S', 's', 'Ś', 'ś',
  'T', 't', 'U', 'u', 'W', 'w', 'Y', 'y', 'Z', 'z',
  'Ź', 'ź', 'Ż', 'ż',
];

const Set<String> polishDiacritics = {
  'Ą', 'ą', 'Ć', 'ć', 'Ę', 'ę', 'Ł', 'ł', 'Ń', 'ń',
  'Ó', 'ó', 'Ś', 'ś', 'Ź', 'ź', 'Ż', 'ż',
};

/// ASCII-safe glyph tokens for the Polish diacritics, matching the file names
/// of the Elementarz-2 writing-guide SVGs (the storage layer can't keep
/// ą/ć/ż in filenames).
const Map<String, String> _glyphTokens = {
  'ą': 'aogonek', 'ć': 'cacute', 'ę': 'eogonek', 'ł': 'lstroke',
  'ń': 'nacute', 'ó': 'oacute', 'ś': 'sacute', 'ź': 'zacute', 'ż': 'zdot',
};

/// Maps a Polish letter to the writing-guide SVG file base name, e.g.
/// 'Ć' → 'upper_Cacute', 'a' → 'lower_a', 'ł' → 'lower_lstroke'.
String letterGuideSvgName(String letter) {
  final isUpper = letter == letter.toUpperCase();
  final token = _glyphTokens[letter.toLowerCase()] ?? letter.toLowerCase();
  if (isUpper) {
    return 'upper_${token[0].toUpperCase()}${token.substring(1)}';
  }
  return 'lower_$token';
}
