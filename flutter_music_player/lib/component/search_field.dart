import 'package:flutter/material.dart';

import '../app/color_ext.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.controller, this.readOnly = false, this.onTap, this.onChanged});
  final TextEditingController controller;
  final bool readOnly;
  final Function()? onTap;
  final Function(String)? onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {

  var isShowClear = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (widget.onChanged != null) widget.onChanged!(value);
        isShowClear = value.isNotEmpty;
        setState(() {});
      },
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      controller: widget.controller,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        suffixIcon:  Visibility(visible: isShowClear,maintainSize: true,maintainState: true,maintainAnimation: true,child: GestureDetector(onTap: () {
          widget.controller.clear();
          isShowClear = false;
          setState(() {});
        },child: const Icon(Icons.close_rounded,),),),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.search,color: Colors.grey,size: 25,),
          ),
          prefixIconConstraints: const BoxConstraints(
              maxWidth: 90
          ),
          hintText: '搜尋',
          fillColor: ColorExt.componentBackground,
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: const BorderSide(width: 0,color: Colors.transparent)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: const BorderSide(width: 0,color: Colors.transparent)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: const BorderSide(width: 0,color: Colors.transparent)),
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10)
      ),
    );
  }
}

