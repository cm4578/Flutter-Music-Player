import 'package:flutter/material.dart';
import 'package:flutter_music_player/component/network_image.dart';

import '../app/color_ext.dart';
import '../model/home.dart';

class RecommendAlbumItem extends StatefulWidget {
  const RecommendAlbumItem({super.key, required this.dataSet, required this.onTap});

  final RecommendAlbum dataSet;
  final Function() onTap;

  @override
  State<RecommendAlbumItem> createState() => _RecommendAlbumItemState();
}

class _RecommendAlbumItemState extends State<RecommendAlbumItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(onTap: widget.onTap,child: Column(
          children: [
            Expanded(child: SizedBox(
              width: 140,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: NetworkSongImage(url: widget.dataSet.thumbnails.firstOrNull?.url,),
              ),
            )),
            Text(widget.dataSet.title,style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
            Text(widget.dataSet.artists!.map((e) => e.name).join(','),style: const TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),)
          ],
        ),),
      ),
    );
  }
}
