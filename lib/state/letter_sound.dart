import 'package:audioplayers/audioplayers.dart';

class LetterSound {
  LetterSound._() {
    _player.audioCache = AudioCache(prefix: '');
  }

  static final LetterSound instance = LetterSound._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String letter) async {
    final file = 'assets/literki_dzwieki/${letter.toUpperCase()}.wav';
    try {
      await _player.stop();
      await _player.play(AssetSource(file));
    } catch (_) {
      // Silently ignore — letter sound is a nice-to-have.
    }
  }
}
