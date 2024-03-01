import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/enums.dart';
import 'package:flutter_music_player/app/global.dart';
import 'package:flutter_music_player/component/home_playlist_item.dart';
import 'package:flutter_music_player/component/recommend_album_item.dart';
import 'package:flutter_music_player/model/home.dart';
import 'package:flutter_music_player/ui/album_page.dart';
import 'package:http/http.dart';

import '../model/Album.dart';

class HomeViewModel extends ChangeNotifier {

  List dataList = [];
  Album? album;

  Home? quickPicks;
  List<Widget> randomWidgetList = [];
  late BuildContext context;
  final TextEditingController searchController = TextEditingController();


  HomeViewModel(this.context);

  fetchHomeData() async {
    try {
      var response = await get(Uri.parse("${Global.baseUrl}/getHome"));
      var responseString = utf8.decode(response.bodyBytes);
      if (response.statusCode != 200) throw Exception(responseString);

      dataList = json.decode(responseString) as List;
      quickPicks = Home<SingSong>.fromJson(dataList.where((e) => e['title'].toString().contains('Quick')).first,(e) => SingSong.fromJson(e));
      dataList.skip(1).forEach((e) {
        randomWidgetList.add(getHomeWidgetList(e));
      });
      notifyListeners();
    } catch(error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('獲取資料失敗')));
      print(error.toString());
    }
  }

  fetchAlbumData(String browseId) async {
    try {
      var response = await get(Uri.parse("${Global.baseUrl}/getAlbum/$browseId"));
      var responseString = utf8.decode(response.bodyBytes);
      if (response.statusCode != 200) throw Exception(responseString);
      album = Album.fromJson(json.decode(responseString));



      notifyListeners();
    } catch(error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('獲取資料失敗')));
      print(error.toString());
    }
  }


  Widget getHomeWidgetList(Map<String,dynamic> dataSet) {
    var title = dataSet['title'];
    var contents = dataSet['contents'] as List;
    var type = getType(title);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25,),
        Text(title,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 23),),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView.builder(padding: const EdgeInsets.symmetric(vertical: 10),scrollDirection: Axis.horizontal,itemBuilder: (context,index) {
            return getHomeWidget(type,contents[index], () {
              // 根據type來導向頁面
              if (type == HomeType.albums) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumPage(browseId: contents[index]['browseId'].toString())));
              }
            });
          },shrinkWrap: true,itemCount: contents.length,),
        )
      ],
    );
  }
  HomeType getType(String title) {
    if (title.contains('Feeling')) {
      return HomeType.feeling;
    }
    if (title.contains('Sooth')) {
      return HomeType.sooth;
    }
    if (title.contains('zone')) {
      return HomeType.inZone;
    }
    if (title.contains('Pop')) {
      return HomeType.pop;
    }
    if (title.contains('Recommend')) return HomeType.albums;
    return HomeType.pop;
  }

  Widget getHomeWidget(HomeType type,Map<String,dynamic> dataSet,Function() onTap) {
    if (type == HomeType.albums) {
      return RecommendAlbumItem(dataSet: RecommendAlbum.fromJson(dataSet), onTap: onTap);
    }
    return HomePlayListItem(dataSet: HomePlayList.fromJson(dataSet), onTap: onTap);
  }
}