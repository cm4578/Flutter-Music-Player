import 'package:flutter/material.dart';
import 'package:flutter_music_player/component/network_image.dart';
import 'package:flutter_music_player/model/home.dart';

class HomePlayListItem extends StatefulWidget {
  const HomePlayListItem({Key? key, required this.dataSet, required this.onTap}) : super(key: key);
  final HomePlayList dataSet;
  final Function() onTap;

  @override
  State<HomePlayListItem> createState() => _HomePlayListItemState();
}

class _HomePlayListItemState extends State<HomePlayListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 150,
        child: GestureDetector(onTap: widget.onTap,child: Column(
          children: [
            Expanded(child: SizedBox(
              width: 140,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: NetworkSongImage(url: widget.dataSet.thumbnails.first.url,),
              ),
            )),
            Text(widget.dataSet.title,style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
            Text(widget.dataSet.description,style: const TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis)
          ],
        ),),
      ),
    );
  }
}
