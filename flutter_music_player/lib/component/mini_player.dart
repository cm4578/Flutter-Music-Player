import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/global.dart';
import 'package:flutter_music_player/component/network_image.dart';
import 'package:flutter_music_player/model/track.dart';
import 'package:flutter_music_player/view_model/audio_play_utils.dart';

import '../app/color_ext.dart';

class MiniPlayer extends StatefulWidget {
  const
  MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {

  late Track currentSong;

  @override
  void initState() {
    super.initState();

    currentSong = AudioPlayUtils.trackList[AudioPlayUtils.audioPlayer.currentIndex ?? 0];

    AudioPlayUtils.audioPlayer.currentIndexStream.asBroadcastStream().listen((index) {
      if (index == null) return;
      currentSong = AudioPlayUtils.trackList[index];
      setState(() {});
    });
    AudioPlayUtils.audioPlayer.playerStateStream.asBroadcastStream().listen((status) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
      color: ColorExt.componentBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 50,
              width: 50,
              child: Card(
                color: Colors.grey,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: NetworkSongImage(url: currentSong.thumbnail[1]!.url),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentSong.title,style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                Text(currentSong.artists.map((e) => e.name).join(', '),style: const TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)
              ],
            )),
            const SizedBox(width:20,),
            Row(children: [
              GestureDetector(onTap: AudioPlayUtils.previous,child: const Icon(Icons.skip_previous_rounded,color: Colors.black,),),
              GestureDetector(onTap: AudioPlayUtils.play,child: Icon(AudioPlayUtils.audioPlayer.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,color: Colors.black,size: 40,),),
              GestureDetector(onTap: AudioPlayUtils.next,child: const Icon(Icons.skip_next_rounded,color: Colors.black,),),
            ],),
            const SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }
}
