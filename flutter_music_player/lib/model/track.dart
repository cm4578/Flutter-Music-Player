import 'package:flutter_music_player/model/Album.dart';
import 'package:flutter_music_player/model/home.dart';
import 'package:flutter_music_player/model/thumbnail.dart';

import 'artists.dart';

class Track {
  String videoId;
  String title;
  String length;
  HomeAlbum? album;
  String? year;
  List<Artist> artists;
  List<Thumbnail?> thumbnail;

  Track(this.videoId, this.title, this.length,this.album,this.year,this.artists,this.thumbnail);

  factory Track.fromJson(Map<String, dynamic> json) {
    print('videoId: ${json['videoId']}');
    print('title: ${json['videoId']}');

    print('length: ${json['videoId']}');
    print('album: ${json['album']}');
    print('year: ${json['year']}');
    print('thumbnail: ${json['thumbnail']}');
    return Track(
        json['videoId'],
        json['title'],
        json['length'],
        json['album'] != null ? HomeAlbum.fromJson(json['album']) : null,
        json['year'],
        (json['artists'] as List).map((e) => Artist.fromJson(e)).toList(),
        (json['thumbnail'] as List).map((e) => Thumbnail.fromJson(e)).toList(),
    );
  }
}