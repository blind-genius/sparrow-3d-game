import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_constants.dart';

class AudioManager {
  static final AudioManager instance = AudioManager._internal();
  AudioManager._internal();

  bool _soundEnabled = true;
  bool get isSoundEnabled => _soundEnabled;

  final Map<String, AudioPlayer> _players = {};

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _soundEnabled = prefs.getBool(AppConstants.keySoundEnabled) ?? true;
    } catch (e) {
      if (kDebugMode) print('Audio init warning: $e');
    }
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keySoundEnabled, _soundEnabled);
    } catch (e) {
      if (kDebugMode) print('Sound toggle save error: $e');
    }
  }

  Future<void> playSfx(String soundName) async {
    if (!_soundEnabled) return;

    try {
      // Re-use or instantiate audio player for low latency
      AudioPlayer player;
      if (_players.containsKey(soundName)) {
        player = _players[soundName]!;
      } else {
        player = AudioPlayer();
        player.setReleaseMode(ReleaseMode.stop);
        _players[soundName] = player;
      }

      await player.stop();
      await player.play(AssetSource('audio/$soundName.wav'));
    } catch (e) {
      // Gracefully catch any platform sound buffer issues
      if (kDebugMode) print('SFX play error ($soundName): $e');
    }
  }

  void playChirp() => playSfx('chirp');
  void playFlap() => playSfx('flap');
  void playWater() => playSfx('water');
  void playSeed() => playSfx('seed');
  void playHit() => playSfx('hit');
  void playWin() => playSfx('level_win');
  void playGameOver() => playSfx('game_over');

  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}
