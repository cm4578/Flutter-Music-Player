import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/global.dart';
import 'package:flutter_music_player/component/material_hero.dart';
import 'package:flutter_music_player/component/search_field.dart';
import 'package:flutter_music_player/ui/search/search_category_page.dart';
import 'package:http/http.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();
  var keywords = <String>[];

  Future search(String value) async {
    if (value.isEmpty) {
      keywords.clear();
      setState(() {});
      return;
    }
    try {
      var response = await get(Uri.parse('${Global.baseUrl}/searchKeyWords/$value'));
      var responseString = utf8.decode(response.bodyBytes);
      if (response.statusCode != 200) throw Exception(responseString);
      keywords = (json.decode(responseString) as List).map((e) => e.toString()).toList();
      setState(() {});
    } catch(error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: MaterialHero(tag: 'field',child: SearchField(controller: searchController,onChanged: search,),),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back_rounded,color: Colors.black,),),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white.withOpacity(0.4),
        child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 15),itemBuilder: (context,index) {
          return _buildItem(index);
        },itemCount: keywords.length),
      ),
    );
  }


  Padding _buildItem(int index) {
    return Padding(
          padding: const EdgeInsets.only(top: 10,bottom: 0),
          child: InkWell(onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCategoryPage(query: keywords[index],)));
          },child: Column(children: [
            Row(
              children: [
                const Icon(Icons.search,color: Colors.grey,),
                const SizedBox(width: 10,),
                Text(keywords[index].toString(),)
              ],
            ),
            const Divider()
          ],),),
        );
  }

}
