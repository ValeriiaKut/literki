import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/state/speech_service.dart';

void main() {
  group('SpeechService.matches', () {
    test('accepts an exact reading', () {
      expect(SpeechService.matches('mama', 'mama'), isTrue);
      expect(SpeechService.matches('tata', 'TATA'), isTrue);
      expect(SpeechService.matches('samochód', 'samochód'), isTrue);
    });

    test('rejects a different equally-short word (the mama/tata bug)', () {
      expect(SpeechService.matches('mama', 'tata'), isFalse);
      expect(SpeechService.matches('tata', 'mama'), isFalse);
      expect(SpeechService.matches('kot', 'kos'), isFalse);
      expect(SpeechService.matches('nos', 'los'), isFalse);
    });

    test('ignores diacritics and surrounding words', () {
      expect(SpeechService.matches('dłoń', 'dlon'), isTrue);
      expect(SpeechService.matches('ołówek', 'to jest ołówek'), isTrue);
    });

    test('tolerates a small slip in longer words only', () {
      expect(SpeechService.matches('samochód', 'samochut'), isTrue); // 2 off, len 8
      expect(SpeechService.matches('telefon', 'telefom'), isTrue); // 1 off, len 7
      expect(SpeechService.matches('mama', 'lala'), isFalse); // 2 off, len 4
    });

    test('syllables: exact or contained, never a near-neighbour', () {
      expect(SpeechService.matches('ma', 'ma'), isTrue);
      expect(SpeechService.matches('ma', 'mama'), isTrue); // contains the syllable
      expect(SpeechService.matches('ma', 'na'), isFalse);
      expect(SpeechService.matches('lo', 'la'), isFalse);
    });
  });
}
