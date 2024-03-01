import 'package:flutter_music_player/model/thumbnail.dart';
import 'package:flutter_music_player/model/track.dart';
import 'artists.dart';

class Album {
  String title;
  List<Thumbnail> thumbnails;
  String year;
  int trackCount;
  List<Artist> artists;
  String duration;
  String audioPlaylistId;
  List<AlbumTrack> tracks;

  Album({required this.title, required this.thumbnails, required this.year, required this.trackCount, required this.artists, required this.duration, required this.audioPlaylistId, required this.tracks});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        title: json['title'],
        thumbnails: (json['thumbnails'] as List).map((e) => Thumbnail.fromJson(e)).toList(),
        year: json['year'],
        trackCount: json['trackCount'],
        artists: (json['artists'] as List).map((e) => Artist.fromJson(e)).toList(),
        duration: json['duration'],
        audioPlaylistId: json['audioPlaylistId'],
        tracks: (json['tracks'] as List).map((e) => AlbumTrack.fromJson(e)).toList()
    );
  }
}

class AlbumTrack {

  String videoId;
  String title;
  int trackNumber;
  String duration;
  String views;
  int durationSeconds;
  List<Artist> artists;

  AlbumTrack(this.videoId,this.title, this.trackNumber, this.duration, this.views, this.durationSeconds, this.artists);

  factory AlbumTrack.fromJson(Map<String, dynamic> json) {
    return AlbumTrack(
        json['videoId'],
        json['title'],
        json['trackNumber'],
        json['duration'],
        json['views'],
        json['duration_seconds'],
        (json['artists'] as List).map((e) => Artist.fromJson(e)).toList());
  }

  Track toTrack() {
    return Track(videoId, title, duration, null, '', artists, [null]);
  }


}
