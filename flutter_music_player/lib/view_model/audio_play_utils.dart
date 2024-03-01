import 'package:flutter_music_player/model/track.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayUtils {

  static AudioPlayer? _audioPlayer;
  static List<Track> trackList = [];

  static Future play() async {
    if (AudioPlayUtils.audioPlayer.playing) {
      await AudioPlayUtils.audioPlayer.pause();
    } else {
      await AudioPlayUtils.audioPlayer.play();
    }
  }

  static Future next() async {
    await AudioPlayUtils.audioPlayer.seekToNext();
  }
  static Future previous() async {
    await AudioPlayUtils.audioPlayer.seekToPrevious();
  }

  static AudioPlayer get audioPlayer {
    _audioPlayer ??= AudioPlayer();
    return _audioPlayer!;
  }
  static bool get hasPlayerAndData {
    return _audioPlayer != null && trackList.isNotEmpty;
  }

  static dispose() {
    if (_audioPlayer != null) {
      audioPlayer.dispose();
      _audioPlayer = null;
    }
  }
}