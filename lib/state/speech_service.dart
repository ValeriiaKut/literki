import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Singleton wrapper around Polish text-to-speech (`flutter_tts`) and speech
/// recognition (`speech_to_text`) for the reading module.
///
/// Mirrors the fire-and-forget, error-swallowing style of [LetterSound]: speech
/// is a teaching aid, never a hard gate. Recognition matching is deliberately
/// lenient and every caller always offers a retry, so a misheard child is never
/// told they were "wrong" — only gently encouraged (positive reinforcement).
class SpeechService {
  SpeechService._();
  static final SpeechService instance = SpeechService._();

  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _stt = stt.SpeechToText();

  bool _ttsReady = false;
  bool _sttAvailable = false;
  bool _sttInitTried = false;

  // --- Text to speech -------------------------------------------------------

  Future<void> _ensureTts() async {
    if (_ttsReady) return;
    await _tts.setLanguage('pl-PL');
    await _tts.setSpeechRate(0.42); // slower, clearer for young learners
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);
    _ttsReady = true;
  }

  /// Speak [text] in Polish, cutting off anything currently playing.
  Future<void> speak(String text) async {
    try {
      await _ensureTts();
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // Sound is a nice-to-have — never surface failures to a child.
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  // --- Speech recognition ---------------------------------------------------

  bool get isListening => _stt.isListening;

  /// Initialise the recognizer once, requesting mic/speech permission. Returns
  /// false when speech recognition is unavailable (no engine, denied
  /// permission) so callers can degrade gracefully.
  Future<bool> ensureRecognizer() async {
    if (_sttInitTried) return _sttAvailable;
    _sttInitTried = true;
    try {
      _sttAvailable = await _stt.initialize(
        onError: (_) {},
        onStatus: (_) {},
      );
    } catch (_) {
      _sttAvailable = false;
    }
    return _sttAvailable;
  }

  /// Begin listening for the child's voice. [onResult] fires with the
  /// recognized words and whether the result is final. Returns false if the
  /// recognizer could not start (caller should then simply let the child move
  /// on without penalty).
  Future<bool> startListening({
    required void Function(String words, bool isFinal) onResult,
  }) async {
    final ok = await ensureRecognizer();
    if (!ok) return false;
    try {
      await _stt.listen(
        onResult: (r) => onResult(r.recognizedWords, r.finalResult),
        listenOptions: stt.SpeechListenOptions(
          localeId: 'pl_PL',
          listenFor: const Duration(seconds: 6),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stopListening() async {
    try {
      await _stt.stop();
    } catch (_) {}
  }

  Future<void> cancelListening() async {
    try {
      await _stt.cancel();
    } catch (_) {}
  }

  // --- Lenient matching -----------------------------------------------------

  static const _diacriticsFrom = ['ą', 'ć', 'ę', 'ł', 'ń', 'ó', 'ś', 'ź', 'ż'];
  static const _diacriticsTo = ['a', 'c', 'e', 'l', 'n', 'o', 's', 'z', 'z'];

  /// Lowercase, strip Polish diacritics, drop everything but a–z.
  static String _normalize(String s) {
    var t = s.toLowerCase();
    for (var i = 0; i < _diacriticsFrom.length; i++) {
      t = t.replaceAll(_diacriticsFrom[i], _diacriticsTo[i]);
    }
    return t.replaceAll(RegExp('[^a-z]'), '');
  }

  /// Whether the recognized speech [heard] is a good-enough match for [target]
  /// (a syllable or word). Tolerant by design: exact match, substring either
  /// way, or a small edit distance all count, since recognizers mangle short
  /// utterances and children's speech.
  static bool matches(String target, String heard) {
    final t = _normalize(target);
    if (t.isEmpty) return false;

    final tokens = heard
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .map(_normalize)
        .where((e) => e.isNotEmpty)
        .toList();
    if (tokens.isEmpty) return false;

    final tol = t.length <= 3 ? 1 : 2;

    for (final tok in tokens) {
      if (tok == t) return true;
      if (tok.length >= t.length && tok.contains(t)) return true;
      if (t.length >= tok.length && t.contains(tok) && tok.length >= 2) {
        return true;
      }
      if (_levenshtein(tok, t) <= tol) return true;
    }

    final blob = tokens.join();
    if (blob.contains(t)) return true;
    if (_levenshtein(blob, t) <= tol) return true;
    return false;
  }

  static int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    var prev = List<int>.generate(b.length + 1, (i) => i);
    var curr = List<int>.filled(b.length + 1, 0);
    for (var i = 0; i < a.length; i++) {
      curr[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a[i] == b[j] ? 0 : 1;
        curr[j + 1] = [
          curr[j] + 1,
          prev[j + 1] + 1,
          prev[j] + cost,
        ].reduce((m, e) => e < m ? e : m);
      }
      final tmp = prev;
      prev = curr;
      curr = tmp;
    }
    return prev[b.length];
  }
}
