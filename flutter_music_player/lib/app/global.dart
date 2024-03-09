import 'package:flutter_music_player/model/Album.dart';
import 'package:flutter_music_player/model/home.dart';

import '../model/thumbnail.dart';
import '../model/track.dart';

class Global {

  static String baseUrl = 'http://192.168.0.23:8010';


  static String? getSingleSongImage(List<Thumbnail> thumbnails) {
    if (thumbnails.length == 1) return thumbnails[0].url;
    return thumbnails[1].url;
  }
  static String? getPlayListImage(Track? dataSet) {
    if (dataSet == null) return null;
    return dataSet.thumbnail[2]!.url;
  }
}