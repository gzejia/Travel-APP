import 'dart:convert';
import 'dart:async';
import 'package:go_together/model/search_model.dart';
import 'package:http/http.dart' as http;

const SEARCH_URl =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

/// 检索接口
class SearchDao {
  static Future<SearchModel> fetch(String text) async {
    final response = await http.get(SEARCH_URl + text);

    if (response.statusCode == 200) {
      // 解决中文乱码问题
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      SearchModel model = SearchModel.fromJson(result);
      model.keyword = text;
      return model;
    } else {
      throw Exception('Failed to load search_page.json');
    }
  }
}
