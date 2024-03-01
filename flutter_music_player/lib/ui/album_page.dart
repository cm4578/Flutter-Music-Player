import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/color_ext.dart';
import 'package:flutter_music_player/component/album_header.dart';
import 'package:flutter_music_player/ui/music_player_page.dart';
import 'package:flutter_music_player/view_model/home_view_model.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key, required this.browseId});

  final String browseId;

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {

  late HomeViewModel _viewModel;
  final ScrollController scrollController = ScrollController();
  var isOverHeader = false;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(context);
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((
        timeStamp) async {
      await _viewModel.fetchAlbumData(widget.browseId);
    });
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: isOverHeader ? FloatingActionButton(onPressed: play
        ,backgroundColor: Colors.blue,child: const Icon(Icons.play_arrow_rounded,color: Colors.white,size: 40,),)  : null,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: isOverHeader ? Colors.white :Colors.transparent,
        elevation: 0,
        title: AnimatedOpacity(
          opacity: isOverHeader ? 1 : 0,
          duration: const Duration(milliseconds: 600),
          child: Text(_viewModel.album?.title ?? '', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        ),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black,)),
      ),
      body: Stack(
        children: [
          if (_viewModel.album == null) Align(
            alignment: Alignment.center, child: CircularProgressIndicator(
            color: ColorExt.componentBackground,
          ),),
          if (_viewModel.album != null) SingleChildScrollView(
            controller: scrollController,
            child: Column(children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 30,),

              AlbumHeader(scrollController: scrollController, album: _viewModel.album!,onTap: play,onOver: (isOver) {
                if (isOver == isOverHeader) return;
                isOverHeader = isOver;
                setState(() {});
              },),
              const SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 15),child: Row(children: [
                    const Text('Songs', style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),),
                    const Spacer(),
                    Text('共${_viewModel.album!.trackCount}首',style: const TextStyle(fontWeight: FontWeight.bold),)
                  ],),),
                  ListView.builder(physics: const NeverScrollableScrollPhysics(),padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),itemBuilder: (context,index) {
                    final dataSet = _viewModel.album!.tracks[index];
                    return ListTile(
                      leading: Text(
                        dataSet.trackNumber.toString(),
                        style: const TextStyle(color: Colors.grey,fontSize: 16),
                      ),
                      title: Text(dataSet.title,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                      subtitle: Text(dataSet.duration,),
                      trailing: GestureDetector(onTap: (){

                      }, child: const Icon(Icons.more_vert_rounded,color: Colors.grey,)),
                    );
                  },shrinkWrap: true,itemCount: _viewModel.album!.trackCount,)
                ],
              )
            ],
            ),
          )
        ],
      ),
    );
  }

  Future play() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MusicPlayerPage(trackList: _viewModel.album!.tracks.map((e) {
      return e.toTrack()..thumbnail = _viewModel.album!.thumbnails..year = _viewModel.album!.year;
    }).toList(),)));
  }
}
