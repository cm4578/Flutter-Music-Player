import 'dart:convert';

import 'package:flutter/material.dart';

import '../../app/global.dart';
import '../../component/network_image.dart';
import '../../model/home.dart';
import '../../model/search.dart';
import '../../model/thumbnail.dart';
import '../../utils/api_utils.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key, this.dataSet,required this.query, required this.filter, });

  final dynamic dataSet;
  final String query;
  final String filter;

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> with AutomaticKeepAliveClientMixin {

  var searchResults = <dynamic>[];

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await fetchSearchResult(widget.filter, widget.query);
    });
  }

  fetchSearchResult(String filter,String query) async {
    try {
      var responseString = await ApiUtils.get('/search/$filter/$query');
      searchResults = json.decode(responseString) as List;
      setState(() {});
    } catch(e) {
      if (context.mounted) ApiUtils.handleErrorSnackBar(context);
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListView.builder(itemBuilder: (context,index) {
        if (widget.filter == 'songs') {
          final dataSet = SingSong.fromJson(searchResults[index]);
          return _buildItem(dataSet.title,dataSet.artists!.map((e) => e.toString()).join(','),dataSet.thumbnails);
        }
        if (widget.filter == 'albums') {
          final dataSet = SearchAlbums.fromJson(searchResults[index]);
          return _buildItem(dataSet.title,dataSet.artists!.map((e) => e.toString()).join(','),dataSet.thumbnails);
        }
        if (widget.filter == 'artists') {
          final dataSet = SearchArtist.fromJson(searchResults[index]);
          return _buildItem(dataSet.artist,null,dataSet.thumbnails);
        }
        final dataSet = SearchPlaylist.fromJson(searchResults[index]);
        return _buildItem(dataSet.title,'${dataSet.author}, ${dataSet.itemCount}',dataSet.thumbnails);
      },itemCount: searchResults.length,),
    );
  }


  Widget _buildItem(String title,String? subTitle,List<Thumbnail> thumbnails) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(subTitle == null ? 999 :  10)),
              child: AspectRatio(aspectRatio: 1 / 1,child: NetworkSongImage(url: Global.getSingleSongImage(thumbnails),width: 90,fit: BoxFit.cover,),),
            ),
            const SizedBox(width: 15,),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,children: [
              Text(title,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),overflow: TextOverflow.ellipsis,maxLines: 1),
              const SizedBox(height: 5,),
              if (subTitle != null) Text(subTitle!,style: const TextStyle(fontSize: 13),overflow: TextOverflow.ellipsis,maxLines: 1,),
            ],)),
            const Spacer(),
            const Icon(Icons.more_vert_rounded,color: Colors.grey,)
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
