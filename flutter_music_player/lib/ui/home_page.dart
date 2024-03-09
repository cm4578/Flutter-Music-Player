import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/color_ext.dart';
import 'package:flutter_music_player/component/material_hero.dart';
import 'package:flutter_music_player/component/mini_player.dart';
import 'package:flutter_music_player/component/quick_pick_item.dart';
import 'package:flutter_music_player/component/search_field.dart';
import 'package:flutter_music_player/model/home.dart';
import 'package:flutter_music_player/ui/search/search_page.dart';
import 'package:flutter_music_player/utils/api_utils.dart';
import 'package:flutter_music_player/view_model/audio_play_utils.dart';
import 'package:flutter_music_player/view_model/home_view_model.dart';
import 'music_player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(context);

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await _viewModel.fetchHomeData();
    });

    _viewModel.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Text('Quick picks',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),),
                    const SizedBox(height: 20,),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 10),child: MaterialHero(tag: 'field', child: SearchField(controller: _viewModel.searchController,readOnly: true,onTap: () {
                      Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation,secondaryAnimation) {
                        return const SearchPage();
                      }));
                    },)),),

                    Stack(
                      children: [
                        if (_viewModel.dataList.isEmpty) Align(alignment: Alignment.center,child: Padding(padding: const EdgeInsets.only(top: 60),child: CircularProgressIndicator(color: Colors.blue.withOpacity(0.6),),)),
                        Column(
                          children: [
                            const SizedBox(height: 20,),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.42,
                              child: GridView.builder(scrollDirection: Axis.horizontal,padding: const EdgeInsets.symmetric(horizontal: 5),shrinkWrap: true,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio:  3.5 / 2.5), itemBuilder: (context,index) {
                                var dataSet = _viewModel.quickPicks!.contents[index] as SingSong;
                                return QuickPickItem(dataSet: dataSet, onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MusicPlayerPage(quickPick: dataSet,)));
                                },);
                              },itemCount: getListItemCount(_viewModel.quickPicks),),
                            ),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,children: List.generate(_viewModel.randomWidgetList.length, (index) {
                              return _viewModel.randomWidgetList[index];
                            }),)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          if (AudioPlayUtils.hasPlayerAndData) const MiniPlayer()
        ],
      ),
    );
  }

  int getListItemCount(Home? dataSet) {
    if (dataSet == null) return 0;
    return dataSet.contents.length;
  }
}
