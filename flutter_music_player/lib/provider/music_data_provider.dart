import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/model/track.dart';
import 'package:http/http.dart';

import '../app/global.dart';

class MusicDataProvider {

  final BuildContext context;

  MusicDataProvider(this.context);

  Future<List<Track>> fetchWatchList(String videoId) async {
    try {
      var response = await get(Uri.parse("${Global.baseUrl}/getWatchList/$videoId"));
      var responseString = utf8.decode(response.bodyBytes);
      if (response.statusCode != 200) throw Exception(responseString);
      var trackList = (json.decode(responseString)['tracks'] as List).map((e) => Track.fromJson(e)).toList();
      return trackList;
    } catch(error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('獲取資料失敗')));
      print(error.toString());
      return [];
    }
  }
  Future<String?> getAudioUrl(String videoId) async {
    try {
      var response = await get(Uri.parse("${Global.baseUrl}/getAudioUrl/$videoId"));
      var responseString = utf8.decode(response.bodyBytes);
      if (response.statusCode != 200) throw Exception(responseString);
      return json.decode(responseString)['audioUrl'];
    } catch (error) {
      handleFetchError(error);
      return null;
    }
  }

  void handleFetchError(dynamic error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('獲取資料失敗')));
    }
    print(error.toString());
  }

}