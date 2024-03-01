import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/color_ext.dart';



class CategoryTabBar extends StatefulWidget {
  const CategoryTabBar({Key? key, required this.texts, this.controller}) : super(key: key);

  final List<String> texts;
  final TabController? controller;

  @override
  State<CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List _keys = [];
  bool _buttonTap = false;
  int _currentIndex = 0;

  double _animationValue = 0.0;

  double _prevAniValue = 0.0;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant CategoryTabBar oldWidget) {
    init();
    super.didUpdateWidget(oldWidget);
  }

  void init() {
    for (int index = 0; index < widget.texts.length; index++) {
      _keys.add(GlobalKey());
    }

    widget.controller?.animation?.addListener(_handleTabAnimation);
    widget.controller?.addListener(_handleTabChange);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60.0,
        child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.texts.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  key: _keys[index],
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: _buildTab(index));
            }));
  }

  Widget _buildTab(int index) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            backgroundColor: _getBackgroundColor(index),
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Colors.grey.withOpacity(.5)),
                borderRadius: BorderRadius.circular(7.0))),
        onPressed: () {
          setState(() {
            _buttonTap = true;
            widget.controller?.animateTo(index);
            _setCurrentIndex(index);
          });
        },
        child: Text(
          uppercaseFirstChar(widget.texts[index]),
          style: TextStyle(color: _getForegroundColor(index)),
        ));
  }

  _handleTabAnimation() {
    if (widget.controller != null) {
      _animationValue = widget.controller!.animation!.value;
    }

    if (!_buttonTap && ((_animationValue - _prevAniValue).abs() < 1)) {
      _setCurrentIndex(_animationValue.round());
    }

    // save the previous Animation Value
    _prevAniValue = _animationValue;
  }

  _handleTabChange() {
    if (_buttonTap && widget.controller != null) {
      _setCurrentIndex(widget.controller!.index);
    }

    if (widget.controller?.index == _animationValue.round()) _buttonTap = false;
  }

  _setCurrentIndex(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      setState(() {});
      _scrollTo(index);
    }
  }

  _scrollTo(int index) {
    double screenWidth = MediaQuery.of(context).size.width;

    RenderBox renderBox = _keys[index].currentContext.findRenderObject();
    double size = renderBox.size.width;
    double position = renderBox.localToGlobal(Offset.zero).dx;

    double offset = (position + size / 2) - screenWidth / 2;

    _scrollController.animateTo(offset + _scrollController.offset, duration: const Duration(milliseconds: 150), curve: Curves.easeInOut);
  }


  String uppercaseFirstChar(String value) {
    return "${value.characters.first.toUpperCase()}${value.characters.skip(1)}";
  }

  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      return ColorExt.componentBackground;
    }
    return Colors.transparent;
  }

  _getForegroundColor(int index) {
    if (index == _currentIndex) {
      return Colors.black;
    }
    return Colors.grey;
  }
}