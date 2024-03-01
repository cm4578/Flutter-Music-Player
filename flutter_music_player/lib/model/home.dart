import 'package:flutter_music_player/model/thumbnail.dart';

import 'artists.dart';

class Home<T> {
  String title;
  List<T> contents;

  Home(this.title, this.contents);

  factory Home.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) contentFactory) {
    List<dynamic> jsonContents = json['contents'] as List;
    List<T> contents = jsonContents.map((e) => contentFactory(e)).toList();
    return Home<T>(json['title'], contents);
  }
}

class SingSong {
  String title;
  String? videoId;
  List<Artist>? artists;
  HomeAlbum? album;
  List<Thumbnail> thumbnails;

  SingSong({
    required this.title,
    required this.videoId,
    required this.artists,
    required this.album,
    required this.thumbnails,
  });

  factory SingSong.fromJson(Map<String, dynamic> json) {
    return SingSong(
      title: json['title'],
      videoId: json['videoId'],
      artists: json['artists'] != null
          ? (json['artists'] as List).map((e) => Artist.fromJson(e)).toList()
          : null,
      album: json['album'] != null ? HomeAlbum.fromJson(json['album']) : null,
      thumbnails: json['thumbnails'] != null
          ? (json['thumbnails'] as List).map((e) => Thumbnail.fromJson(e)).toList()
          : [],
    );
  }
}

class HomePlayList {
  String title;
  String playlistId;
  List<Thumbnail> thumbnails;
  String description;

  HomePlayList({
    required this.title,
    required this.playlistId,
    required this.thumbnails,
    required this.description,
  });

  factory HomePlayList.fromJson(Map<String, dynamic> json) {
    return HomePlayList(
      title: json['title'],
      playlistId: json['playlistId'],
      thumbnails: (json['thumbnails'] as List).map((e) => Thumbnail.fromJson(e)).toList(),
      description: json['description'],
    );
  }
}

class RecommendAlbum {
  String title;
  List<Artist>? artists;
  String browseId;
  String audioPlaylistId;
  List<Thumbnail> thumbnails;

  RecommendAlbum({
    required this.title,
    required this.artists,
    required this.browseId,
    required this.audioPlaylistId,
    required this.thumbnails,
  });

  factory RecommendAlbum.fromJson(Map<String, dynamic> json) {
    return RecommendAlbum(
      title: json['title'],
      artists: json['artists'] != null ? (json['artists'] as List).map((e) => Artist.fromJson(e)).toList() : null,
      browseId: json['browseId'],
      audioPlaylistId: json['audioPlaylistId'],
      thumbnails: json['thumbnails'] != null ? (json['thumbnails'] as List).map((e) => Thumbnail.fromJson(e)).toList() : [],
    );
  }
}

class HomeAlbum {
  String name;
  String id;

  HomeAlbum({
    required this.name,
    required this.id,
  });

  factory HomeAlbum.fromJson(Map<String, dynamic> json) {
    return HomeAlbum(name: json['name'], id: json['id']);
  }
}

