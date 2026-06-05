import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static AudioPlayer? _musicPlayer;

  static bool _initialized = false;

  static Future<void> _init() async {
    if (_initialized) return;

    _initialized = true;

    final audioContext = AudioContext(
      iOS: AudioContextIOS(
        category:
            AVAudioSessionCategory.playback,
        options: const {
          AVAudioSessionOptions
              .mixWithOthers,
        },
      ),

      // QUESTO È IL FIX
      android: AudioContextAndroid(
        audioFocus:
            AndroidAudioFocus.none,
        usageType:
            AndroidUsageType.game,
        contentType:
            AndroidContentType.music,
        isSpeakerphoneOn: false,
        stayAwake: false,
      ),
    );

    await AudioPlayer.global
        .setAudioContext(
      audioContext,
    );

    _musicPlayer = AudioPlayer();

    await _musicPlayer!.setReleaseMode(
      ReleaseMode.loop,
    );

    await _musicPlayer!.setPlayerMode(
      PlayerMode.mediaPlayer,
    );

    await _musicPlayer!.setVolume(
      0.75,
    );
  }

  // =========================
  // MUSIC
  // =========================

  static Future<void> playLevelMusic(
    String path,
  ) async {
    try {
      await _init();

      await _musicPlayer?.stop();

      await Future.delayed(
        const Duration(
          milliseconds: 50,
        ),
      );

      await _musicPlayer?.play(
        AssetSource(path),
        volume: 0.75,
      );
    } catch (e) {
      debugPrint(
        'playLevelMusic error: $e',
      );
    }
  }

  static Future<void> stopMusic() async {
    try {
      await _musicPlayer?.stop();
    } catch (e) {
      debugPrint(
        'stopMusic error: $e',
      );
    }
  }

  static Future<void> pauseMusic() async {
    try {
      await _musicPlayer?.pause();
    } catch (e) {
      debugPrint(
        'pauseMusic error: $e',
      );
    }
  }

  static Future<void> resumeMusic() async {
    try {
      await _musicPlayer?.resume();
    } catch (e) {
      debugPrint(
        'resumeMusic error: $e',
      );
    }
  }

  // =========================
  // SFX
  // =========================

  static Future<void> _playSfx(
    String path,
    double volume,
  ) async {
    try {
      final player = AudioPlayer();

      await player.setAudioContext(
        AudioContext(
          android:
              AudioContextAndroid(
            audioFocus:
                AndroidAudioFocus.none,
            usageType:
                AndroidUsageType.game,
            contentType:
                AndroidContentType
                    .sonification,
          ),
        ),
      );

      await player.setPlayerMode(
        PlayerMode.lowLatency,
      );

      await player.play(
        AssetSource(path),
        volume: volume,
      );

      player.onPlayerComplete.listen((
        _,
      ) {
        player.dispose();
      });
    } catch (e) {
      debugPrint(
        'SFX error: $e',
      );
    }
  }

  static Future<void> playPerfect() async {
    await _playSfx(
      'sounds/perfect.wav',
      1.0,
    );
  }

  static Future<void> playGood() async {
    await _playSfx(
      'sounds/good.wav',
      1.0,
    );
  }

  static Future<void> playMiss() async {
    await _playSfx(
      'sounds/miss.wav',
      0.85,
    );
  }
}