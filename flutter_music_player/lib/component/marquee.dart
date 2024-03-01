import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/color_ext.dart';

class Marquee extends StatefulWidget {
  const Marquee({super.key, required this.text, this.style});
  final String text;
  final TextStyle? style;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {

  ScrollController scrollController = ScrollController();
  double childHeight = 40;
  final marqueeTextKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      var renderBox = marqueeTextKey.currentContext!.findRenderObject() as RenderBox;
      childHeight = renderBox.size.height;

      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
      scroll(timeStamp);
    });
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(const Duration(seconds: 1));
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.ease,
        );
      }
      await Future.delayed(const Duration(seconds: 1));
      if (scrollController.hasClients) {
        scrollController.jumpTo(0.0,);
      }
    }
  }
  
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: childHeight,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Text(widget.text,style: widget.style,maxLines: 1,key: marqueeTextKey,),
          ),
        ),
        // Container(decoration: BoxDecoration(
        //   gradient: LinearGradient(begin: Alignment.centerLeft,end: Alignment.centerRight,colors: [ColorExt.componentBackground,ColorExt.componentBackground.withOpacity(0)])
        // ),width: 15,),
      ],
    );
  }
}
