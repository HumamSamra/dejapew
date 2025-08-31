import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static double volume = 100;
  static final player = AudioPlayer();

  static void playSound(
    String key, {
    bool multi = true,
    bool lowLatency = true,
  }) async {
    final soundVolume = (volume / 100).clamp(0.0, 1.0);
    if (volume > 0) {
      final String path = 'sounds/$key';
      if (player.state == PlayerState.playing && multi) {
        final altPlayer = AudioPlayer();
        altPlayer.play(
          AssetSource(path),
          volume: soundVolume,
          mode: lowLatency ? PlayerMode.lowLatency : null,
        );
        altPlayer.onPlayerComplete.listen((_) async {
          altPlayer.dispose();
        });
      } else {
        if (player.state == PlayerState.playing) {
          player.stop();
        }
        player.play(
          AssetSource(path),
          volume: soundVolume,
          mode: lowLatency ? PlayerMode.lowLatency : null,
        );
      }
    }
  }
}
