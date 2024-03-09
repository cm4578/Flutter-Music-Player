import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/color_ext.dart';
import 'package:flutter_music_player/component/network_image.dart';
import 'package:flutter_music_player/model/track.dart';
import 'package:flutter_music_player/utils/compute_utils.dart';
import 'package:flutter_music_player/view_model/audio_play_utils.dart';
import '../app/global.dart';
import '../model/home.dart';
import '../provider/music_data_provider.dart';
import '../ui/playlist_sheet.dart';
import '../view_model/music_player_view_model.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key, this.isFullScreen = false, this.quickPick,this.trackList, });

  final SingSong? quickPick;
  final List<Track>? trackList;
  final bool isFullScreen;

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {

  late MusicPlayerViewModel _viewModel;

  DraggableScrollableController dragController = DraggableScrollableController();
  var scale = .35;
  double bigContentSizeAlpha = 0;
  double smallContentSizeAlpha = 1;
  double minPlayerSize = 220;
  double minPlayerContentLeft = 0;

  late Track currentSong;

  double musicImagePaddingTop = 5.0;
  double musicImagePaddingHorizontal = 5.0;
  double safeAreaPaddingTop = 0.0;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicPlayerViewModel(context,MusicDataProvider(context));


    currentSong = AudioPlayUtils.trackList[AudioPlayUtils.audioPlayer.currentIndex ?? 0];
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      minPlayerSize = MediaQuery.of(context).size.height - AppBar().preferredSize.height * .15;
      safeAreaPaddingTop = MediaQuery.of(context).padding.top * ComputeUtils.calculatorPercentage(dragController.size, .0, 1);

      scale = .15;
      setState(() {});
    });
    dragController.addListener(() {
      updateAlphaAndScale();
    });

    AudioPlayUtils.audioPlayer.currentIndexStream.asBroadcastStream().listen((index) {
      if (index == null) return;
      currentSong = AudioPlayUtils.trackList[index];
      setState(() {});
    });
    AudioPlayUtils.audioPlayer.playerStateStream.asBroadcastStream().listen((status) {
      setState(() {});
    });
  }
  void updateAlphaAndScale() {
    bigContentSizeAlpha = ComputeUtils.calculatorPercentage(dragController.size, childSize, 1);
    smallContentSizeAlpha = 1 - dragController.size;
    scale = dragController.size.clamp(0.15, 1.0); // Using clamp for better readability
    minPlayerContentLeft = MediaQuery.of(context).size.width * ComputeUtils.calculatorPercentage(dragController.size, 0, 1.0);

    musicImagePaddingTop = (60 * ComputeUtils.calculatorPercentage(dragController.size, .35, 1)).clamp(5.0, 60.0);
    musicImagePaddingHorizontal = (30 * ComputeUtils.calculatorPercentage(dragController.size, .35, 1)).clamp(5.0, 30.0);
    safeAreaPaddingTop = MediaQuery.of(context).padding.top * ComputeUtils.calculatorPercentage(dragController.size, .0, 1);

    setState(() {});
  }
  double get childSize => .09;


  @override
  void didUpdateWidget(covariant MiniPlayer oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        snap: true,
        controller: dragController,
        minChildSize: childSize,
        initialChildSize: widget.isFullScreen ? 1 :  childSize,
        maxChildSize: 1,
        builder: (context,scrollController) {
      return SingleChildScrollView(
        controller: scrollController,
        child: Container(
          color: ColorExt.componentBackground,
          padding: EdgeInsets.only(top: safeAreaPaddingTop),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Positioned(left: 0,right: 0,top: 0,child: Opacity(
                        opacity: smallContentSizeAlpha,
                        child: buildMiniContent(),
                      )),
                      Opacity(opacity: bigContentSizeAlpha,child: Padding(
                        padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                        child: Row(
                          children: [
                            GestureDetector(onTap: () {
                              dragController.animateTo(childSize, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                            },child: const Icon(Icons.keyboard_arrow_down_rounded,color: Colors.black,size: 30,),),
                            const Spacer(),
                            GestureDetector(onTap: () {

                            },child: const Icon(Icons.more_vert_rounded,color: Colors.black,size: 30,),)
                          ],
                        ),
                      ),),
                      Padding(
                        padding: EdgeInsets.only(top: musicImagePaddingTop,left: musicImagePaddingHorizontal,right: musicImagePaddingHorizontal),
                        child: videoPlayerView(),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // AspectRatio(aspectRatio: 1.2,child: Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20),
                        //   height: MediaQuery.of(context).size.height * 0.3,
                        //   child: Card(
                        //     elevation: 10,
                        //     margin: const EdgeInsets.symmetric(horizontal: 20),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20)
                        //     ),
                        //     clipBehavior: Clip.antiAliasWithSaveLayer,
                        //     child: NetworkSongImage(url: Global.getPlayListImage(_viewModel.currentSong),fit: BoxFit.cover,),
                        //   ),
                        // )),
                        Text(currentSong?.title ?? '',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        const SizedBox(height: 5,),
                        Text((currentSong?.artists ?? []).map((e) => e.name).join(','),style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 14),),
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
                      ],
                    ),
                  ),
                ],
              ),
              PlayListSheet(trackList: AudioPlayUtils.trackList, currentIndex: AudioPlayUtils.audioPlayer.currentIndex ?? 0,onScroll: (delta) {
              }, onItemTap: (index) {
                AudioPlayUtils.audioPlayer.seek(null,index: index);
                setState(() {});
              },),
            ],
          ),
        ),
      );
    });
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

  Widget buildMiniContent() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(opacity: 0,child: AspectRatio(aspectRatio: 1,child: NetworkSongImage(
            url: currentSong.thumbnail[1]!.url,
            width: MediaQuery.of(context).size.width * .15,
            fit: BoxFit.cover,
          ),),),
          const SizedBox(width: 10,),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currentSong.title,style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
              Text(currentSong.artists.map((e) => e.name).join(', '),style: const TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)
            ],
          )),
          const SizedBox(width:20,),
          GestureDetector(onTap: AudioPlayUtils.previous,child: const Icon(Icons.skip_previous_rounded,color: Colors.black,),),
          GestureDetector(onTap: AudioPlayUtils.play,child: Icon(AudioPlayUtils.audioPlayer.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,color: Colors.black,size: 40,),),
          GestureDetector(onTap: AudioPlayUtils.next,child: const Icon(Icons.skip_next_rounded,color: Colors.black,),),
          const SizedBox(width: 10,),
        ],
      ),
    );
  }


  Widget videoPlayerView() {
    return Transform.scale(scale: scale,alignment: Alignment.topLeft,child: Card(
      elevation: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: AspectRatio(aspectRatio: 1,child: NetworkSongImage(
        url: currentSong.thumbnail[1]!.url,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),),
    ),);
  }
}
