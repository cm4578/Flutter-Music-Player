import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/global.dart';
import 'package:flutter_music_player/component/network_image.dart';

import '../app/color_ext.dart';
import '../model/home.dart';

class QuickPickItem extends StatefulWidget {
  const QuickPickItem({super.key, required this.dataSet, required this.onTap});

  final SingSong dataSet;
  final Function() onTap;

  @override
  State<QuickPickItem> createState() => _QuickPickItemState();
}

class _QuickPickItemState extends State<QuickPickItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(onTap: widget.onTap,child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: NetworkSongImage(url: Global.getSingleSongImage(widget.dataSet.thumbnails)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text(widget.dataSet.title,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,),
              Text(widget.dataSet.artists!.first.name,style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 14),maxLines: 1,overflow: TextOverflow.ellipsis,),
            ],),
          )
        ],
      ),),
    );
  }

  Widget _buildImage(String? url) {
    return url == null ? Container(
      alignment: Alignment.center,
      color: ColorExt.componentBackground,
      child: const Icon(Icons.music_note,color: Colors.grey,size: 30,),
    ) :  Image.network(url,fit: BoxFit.cover,width: double.infinity,);
  }
}
