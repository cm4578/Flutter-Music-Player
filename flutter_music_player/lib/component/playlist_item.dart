import 'package:flutter/material.dart';
import 'package:flutter_music_player/model/track.dart';

class PlayListItem extends StatefulWidget {
  const PlayListItem({super.key, required this.dataSet, this.isSelected = false, required this.onTap});
  final Track dataSet;
  final bool isSelected;
  final Function() onTap;

  @override
  State<PlayListItem> createState() => _PlayListItemState();
}

class _PlayListItemState extends State<PlayListItem> {

  var side = BorderSide(color: Colors.white.withOpacity(0.2), width: 1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(onTap: widget.onTap,child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15)),border: Border(top: side,left: side,bottom: side)
              ),
              child: AspectRatio(aspectRatio: 1,child: Image.network(widget.dataSet.thumbnail.first!.url,width: 60,fit: BoxFit.cover,),),
            ),
            Expanded(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border(top: side,bottom: side,right: side),
                  color: widget.isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15),topRight: Radius.circular(15))
              ),
              child: Row(
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Text(widget.dataSet.title,style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 5,),
                      Text(widget.dataSet.artists.map((e) => e.name).join(','),style: TextStyle(fontSize: 12,color: Colors.white.withOpacity(0.4)),),
                    ],
                  )),
                  const SizedBox(width: 10,),
                  Text(widget.dataSet.length,style: const TextStyle(color: Colors.grey,fontSize: 13),),
                ],
              ),
            )),
          ],
        ),
      ),),
    );
  }
}
