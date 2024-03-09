import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/color_ext.dart';
import 'package:flutter_music_player/component/playlist_item.dart';

import '../model/track.dart';
import '../utils/compute_utils.dart';

class PlayListSheet extends StatefulWidget {
  const PlayListSheet({super.key, required this.trackList, required this.currentIndex, this.onScroll, required this.onItemTap});

  final List<Track> trackList;
  final int currentIndex;
  final Function(double)? onScroll;
  final Function(int) onItemTap;

  @override
  State<PlayListSheet> createState() => _PlayListSheetState();
}

class _PlayListSheetState extends State<PlayListSheet> {
  final DraggableScrollableController scrollController =   DraggableScrollableController();
  var toolAlpha = 1.0;
  var listAlpha = 0.0;
  var trackList = <Track>[];

  @override
  void initState() {
    super.initState();
    trackList = widget.trackList;
    scrollController.addListener(() {
      if (widget.onScroll != null) widget.onScroll!(scrollController.size);
      toolAlpha = 1 - ComputeUtils.calculatorPercentage(scrollController.size, .09, .2).clamp(0.0, 1.0);
      listAlpha = ComputeUtils.calculatorPercentage(scrollController.size, .09, .2).clamp(0.0, 1.0);
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant PlayListSheet oldWidget) {
    if (oldWidget.trackList != trackList) {
      trackList = widget.trackList;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
   }
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        snap: true,
        controller: scrollController,
        minChildSize: .08,
        maxChildSize: 1,
        initialChildSize: .08,
        builder: (context, controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: ColorExt.playlistBgColor,borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: [
                Opacity(
                  opacity: toolAlpha,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(children: [
                      Icon(Icons.volume_down_rounded,color: Colors.white,size: 25,),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_up_rounded,color: Colors.white,size: 30,),
                      Spacer(),
                      Icon(Icons.auto_fix_off_rounded,color: Colors.white,size: 25,),
                    ],),
                  ),
                ),
                Opacity(opacity: listAlpha,child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  controller: controller,
                  itemBuilder: (context, index) {
                    var dataSet = trackList[index];

                    return PlayListItem(dataSet: dataSet,isSelected: widget.currentIndex == index, onTap: () {
                      widget.onItemTap(index);
                    },);
                  }, itemCount: trackList.length,),)
              ],
            ),
          );
        });
  }


}
