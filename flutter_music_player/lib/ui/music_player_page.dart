import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/color_ext.dart';
import 'package:flutter_music_player/app/global.dart';
import 'package:flutter_music_player/component/marquee.dart';
import 'package:flutter_music_player/component/network_image.dart';
import 'package:flutter_music_player/model/track.dart';
import 'package:flutter_music_player/provider/music_data_provider.dart';
import 'package:flutter_music_player/ui/playlist_sheet.dart';
import 'package:flutter_music_player/utils/compute_utils.dart';
import 'package:flutter_music_player/view_model/audio_play_utils.dart';
import 'package:flutter_music_player/view_model/music_player_view_model.dart';
import 'package:just_audio/just_audio.dart';
import '../model/home.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key,this.quickPick, this.trackList, this.currentIndex = 0});

  final SingSong? quickPick;
  final int currentIndex;
  final List<Track>? trackList;

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {


  late MusicPlayerViewModel _viewModel;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;
  int currentIndex = 0;
  var alpha = 1.0;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicPlayerViewModel(context,MusicDataProvider(context));
    AudioPlayUtils.dispose();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      if (widget.trackList != null) {
        _viewModel.trackList = widget.trackList!;
      } else {
        await _viewModel.fetchWatchList(widget.quickPick!.videoId!);
      }
      AudioPlayUtils.trackList = _viewModel.trackList!;
      await _viewModel.fetchAudioSources();

      await AudioPlayUtils.audioPlayer.setAudioSource(ConcatenatingAudioSource(children: _viewModel.audioSources),initialIndex: widget.currentIndex);
      _viewModel.currentSong = _viewModel.trackList[widget.currentIndex];


      setState(() {});
    });

    _playerStateSubscription = AudioPlayUtils.audioPlayer.playerStateStream.listen((event) {
      setState(() {});
    });
    _currentIndexSubscription = AudioPlayUtils.audioPlayer.currentIndexStream.listen((index) {
      if (index == null) return;
      _viewModel.currentSong = _viewModel.trackList[index];
      setState(() {});
    });

    _viewModel.addListener(() => setState(() {}));
  }
  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Opacity(
          opacity: alpha,
          child: const Text('Play List',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
        ),
        elevation: 0,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back_ios_outlined,color: Colors.black,),),
      ),
      backgroundColor: ColorExt.componentBackground,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                AspectRatio(aspectRatio: 1.2,child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Card(
                    elevation: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: NetworkSongImage(url: Global.getPlayListImage(_viewModel.currentSong),fit: BoxFit.cover,),
                  ),
                )),
                const SizedBox(height: 20,),
                Text(_viewModel.currentSong?.title ?? '',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),maxLines: 1,overflow: TextOverflow.ellipsis,),
                const SizedBox(height: 5,),
                Text((_viewModel.currentSong?.artists ?? []).map((e) => e.name).join(','),style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 14),),
                const SizedBox(height: 20,),
                StreamBuilder(stream: AudioPlayUtils.audioPlayer.positionStream, builder: (context,snapshot) {
                  if (!snapshot.hasData) return _buildPositionWidget(const Duration(seconds: 0),const Duration(seconds: 0));
                  return _buildPositionWidget(AudioPlayUtils.audioPlayer.position,AudioPlayUtils.audioPlayer.duration ?? const Duration(seconds: 0));
                }),
                const SizedBox(height: 30,),

                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  IconButton(onPressed: () {

                  }, icon: Icon(Icons.favorite_border,color: Colors.black.withOpacity(0.3),size: 30,)),
                  const SizedBox(width: 15,),
                  const IconButton(onPressed: AudioPlayUtils.previous, icon: Icon(Icons.skip_previous_rounded,color: Colors.black,size: 40,)),
                  const SizedBox(width: 15,),
                  FloatingActionButton(onPressed: AudioPlayUtils.play,backgroundColor: Colors.blue,child: Icon(AudioPlayUtils.audioPlayer.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,color: Colors.white,),),
                  const SizedBox(width: 15,),
                  const IconButton(onPressed: AudioPlayUtils.next, icon: Icon(Icons.skip_next_rounded,color: Colors.black,size: 40,)),
                  const SizedBox(width: 15,),
                  IconButton(onPressed: _viewModel.repeat, icon: Icon(Icons.repeat_rounded,color: Colors.black.withOpacity(_viewModel.isLoop ? 1 : 0.3),size: 30,)),
                ],),
                const Spacer(),
                const SizedBox(height: 10,),
              ],
            ),
          ),
          PlayListSheet(trackList: _viewModel.trackList, currentIndex: AudioPlayUtils.audioPlayer.currentIndex ?? 0,onScroll: (delta) {
            alpha = ComputeUtils.calculatorPercentage(delta, .9, 1).clamp(0.0, 1.0);
            setState(() {});
          }, onItemTap: (index) {
            AudioPlayUtils.audioPlayer.seek(null,index: index);
            setState(() {});
          },),
        ],
      ),
    );
  }


  String getDurationString(Duration duration) {
    return '${(duration.inSeconds ~/ 60).toString().padLeft(2,'0')}:${(duration.inSeconds % 60).toString().padLeft(2,'0')}';
  }

  Column _buildPositionWidget(Duration position,Duration duration) {
    return Column(children: [
      SliderTheme(data: SliderThemeData(overlayShape: SliderComponentShape.noOverlay), child: Slider(value: position.inSeconds.toDouble(),max: duration.inSeconds.toDouble(),min: 0,inactiveColor: Colors.grey.withOpacity(0.2),thumbColor: Colors.red,activeColor: Colors.red, onChanged: (value) {
        AudioPlayUtils.audioPlayer.seek(Duration(seconds: value.round()));
        setState(() {});
      }),),
      const SizedBox(height: 10,),
      Row(
        children: [
          Text(getDurationString(position),style: const TextStyle(color: Colors.grey,fontSize: 12),),
          const Spacer(),
          Text(getDurationString(duration),style: const TextStyle(color: Colors.grey,fontSize: 12),)
        ],
      ),
    ],);
  }


}
