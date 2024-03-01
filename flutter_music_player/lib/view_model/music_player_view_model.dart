import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../model/track.dart';
import '../provider/music_data_provider.dart';
import 'audio_play_utils.dart';

class MusicPlayerViewModel extends ChangeNotifier {

  final BuildContext context;
  final MusicDataProvider provider;

  Track? currentSong;
  List<Track> trackList = [];
  List<AudioSource> audioSources = [];
  var isLoop = false;

  MusicPlayerViewModel(this.context,this.provider);


  fetchWatchList(String videoId) async {
    try {
      trackList = await provider.fetchWatchList(videoId);
      currentSong = trackList.first;
      notifyListeners();
    } catch(error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('獲取資料失敗')));
      print(error.toString());
      return [];
    }
  }

  fetchAudioSources() async {
    audioSources = await Future.wait(
      List.generate(
        trackList.length, (index) async {
          var track = trackList[index];
          var url = await provider.getAudioUrl(track.videoId) ?? '';
          return AudioSource.uri(Uri.parse(url),tag: MediaItem(id: index.toString(), title: track.title));
        },
      ),
    );
  }

  Future repeat() async {
    await AudioPlayUtils.audioPlayer.setLoopMode( isLoop ? LoopMode.all : LoopMode.off);
    isLoop = !isLoop;
    notifyListeners();
  }
}