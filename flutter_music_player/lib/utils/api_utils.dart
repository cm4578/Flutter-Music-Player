import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/app/global.dart';
import 'package:http/http.dart' as http;

class ApiUtils {
  static Future<String> get(String url,{Function(Object error)? onError}) async {
    var response = await http.get(Uri.parse('${Global.baseUrl}$url'));
    var responseString = utf8.decode(response.bodyBytes);
    if (response.statusCode != 200) throw Exception(responseString);
    return responseString;
  }
  static handleErrorSnackBar(BuildContext context,{Object? error}) {
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error?.toString() ?? '獲取資料失敗')));
  }
}