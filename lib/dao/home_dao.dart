import 'dart:convert';
import 'dart:async';
import 'package:go_together/model/home_model.dart';
import 'package:http/http.dart' as http;

const HOME_URl = 'http://www.devio.org/io/flutter_app/json/home_page.json';

/// 首页大接口
class HomeDao{

  static Future<HomeModel> fetch() async{
    final response = await http.get(HOME_URl);

    if(response.statusCode == 200) {
      // 解决中文乱码问题
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}