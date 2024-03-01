import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../model/Album.dart';

class AlbumHeader extends StatefulWidget {
  const AlbumHeader({super.key,required this.scrollController, required this.album,required this.onTap, this.onOver});

  final ScrollController scrollController;
  final Album album;
  final Function() onTap;
  final Function(bool)? onOver;

  @override
  State<AlbumHeader> createState() => _AlbumHeaderState();
}

class _AlbumHeaderState extends State<AlbumHeader> {

  final GlobalKey globalKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      final renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
      var scrollController = widget.scrollController;
      scrollController.addListener(() {
        widgetOpacity = (1 - scrollController.position.pixels / renderBox.size.height).clamp(0.0, 1.0);
        if (scrollController.position.pixels >= renderBox.size.height && widget.onOver != null) {
          widget.onOver!(true);
        }
        if (scrollController.position.pixels <= renderBox.size.height) {
          widget.onOver!(false);
          setState(() {});
        }
      });
    });
  }

  double widgetOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: widgetOpacity,key: globalKey,child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.38 ,
      child: Column(children: [
        Text(widget.album.artists.map((e) => e.name).join(','),style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 16),),
        Expanded(child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
          elevation: 10,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Image.network(widget.album.thumbnails[2].url,fit: BoxFit.cover,),
        )),
        Text(widget.album.title,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
        const SizedBox(height: 3,),
        Text(widget.album.year,style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 14),),
        const SizedBox(height: 3,),
        const SizedBox(height: 5,),
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          const Icon(Icons.download_rounded,color: Colors.grey,size: 30,),
          const SizedBox(width: 30,),
          FloatingActionButton(onPressed: widget.onTap,backgroundColor: Colors.blue,child: const Icon(Icons.play_arrow_rounded,color: Colors.white,size: 40,),),
          const SizedBox(width: 30,),
          const Icon(Icons.share_rounded,color: Colors.grey,size: 25,),
        ],)
      ],),
    ),);
  }
}

