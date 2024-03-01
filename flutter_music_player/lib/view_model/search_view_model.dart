import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_music_player/utils/api_utils.dart';

class SearchViewModel extends ChangeNotifier {
  final BuildContext context;

  SearchViewModel(this.context);


  var filterList = [
    'songs', 'albums', 'artists', 'playlists'
  ];



}