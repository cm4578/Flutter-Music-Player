import 'package:flutter_music_player/model/thumbnail.dart';

import 'artists.dart';

class SearchArtist {
  String radioId;
  String artist;
  String broseId;
  List<Thumbnail> thumbnails;

  SearchArtist(
      {required this.radioId,
      required this.artist,
      required this.broseId,
      required this.thumbnails});

  factory SearchArtist.fromJson(Map<String, dynamic> json) {
    return SearchArtist(
        radioId: json['radioId'],
        artist: json['artist'],
        broseId: json['browseId'],
        thumbnails: (json['thumbnails'] as List)
            .map((e) => Thumbnail.fromJson(e))
            .toList());
  }
}

class SearchPlaylist {
  String title;
  String itemCount;
  String author;
  String browseId;
  List<Thumbnail> thumbnails;

  SearchPlaylist(
      {required this.title,
      required this.itemCount,
      required this.author,
      required this.browseId,
      required this.thumbnails});

  factory SearchPlaylist.fromJson(Map<String, dynamic> json) {
    return SearchPlaylist(
        title: json['title'],
        itemCount: json['itemCount'],
        author: json['author'],
        browseId: json['browseId'],
        thumbnails: (json['thumbnails'] as List).map((e) => Thumbnail.fromJson(e)).toList());
  }
}

class SearchAlbums {
  String title;
  String? duration;
  String year;
  String browseId;
  List<Artist> artists;
  List<Thumbnail> thumbnails;

  SearchAlbums(
      {required this.title,
      required this.duration,
      required this.year,
      required this.browseId,
      required this.artists,
      required this.thumbnails});

  factory SearchAlbums.fromJson(Map<String, dynamic> json) {
    return SearchAlbums(
        title: json['title'],
        duration: json['duration'],
        year: json['year'],
        browseId: json['browseId'],
        artists: (json['artists'] as List).map((e) => Artist.fromJson(e)).toList(),
        thumbnails: (json['thumbnails'] as List).map((e) => Thumbnail.fromJson(e)).toList()
    );
  }
}
