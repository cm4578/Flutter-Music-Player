import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/global.dart';
import 'package:flutter_music_player/model/track.dart';

class NetworkSongImage extends StatefulWidget {
  const NetworkSongImage(
      {super.key,
      required this.url,
      this.height,
      this.width,
      this.fit,
      this.musicIconSize});

  final String? url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double? musicIconSize;

  @override
  State<NetworkSongImage> createState() => _NetworkSongImageState();
}

class _NetworkSongImageState extends State<NetworkSongImage> {
  @override
  Widget build(BuildContext context) {
    return widget.url == null
        ? Icon(
            Icons.music_note_rounded,
            color: Colors.black,
            size: widget.musicIconSize ?? 50,
          )
        : Image.network(
            widget.url!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
  }
}
