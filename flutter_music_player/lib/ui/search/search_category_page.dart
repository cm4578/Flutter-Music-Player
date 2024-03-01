import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/color_ext.dart';
import 'package:flutter_music_player/app/global.dart';
import 'package:flutter_music_player/component/category_tabar.dart';
import 'package:flutter_music_player/component/network_image.dart';
import 'package:flutter_music_player/model/home.dart';
import 'package:flutter_music_player/model/search.dart';
import 'package:flutter_music_player/ui/search/search_result_page.dart';
import 'package:flutter_music_player/view_model/search_view_model.dart';

import '../../model/thumbnail.dart';

class SearchCategoryPage extends StatefulWidget {
  const SearchCategoryPage({super.key, required this.query});

  final String query;

  @override
  State<SearchCategoryPage> createState() => _SearchCategoryPageState();
}

class _SearchCategoryPageState extends State<SearchCategoryPage> with TickerProviderStateMixin {

  late SearchViewModel _viewModel;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    _viewModel = SearchViewModel(context);
    tabController = TabController(length: _viewModel.filterList.length, vsync: this);
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.query,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back_rounded,color: Colors.black,),),
      ),
      body: Column(children: [
        CategoryTabBar(texts: _viewModel.filterList,controller: tabController,),
        Flexible(fit: FlexFit.loose,child: TabBarView(controller: tabController,children: List.generate(_viewModel.filterList.length, (index) {
          return SearchResultPage(query: widget.query, filter: _viewModel.filterList[index]);
        })))
      ],),
    );
  }


}
