import 'package:flutter/material.dart';
import 'package:go_together/dao/search_dao.dart';
import 'package:go_together/model/search_model.dart';
import 'package:go_together/pages/web_view_page.dart';
import 'package:go_together/widget/search_bar.dart';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

/// 检索页
class SearchPage extends StatefulWidget {
  final bool isHideLeft;
  final String keyword;
  final String hintStr;

  const SearchPage({Key key, this.isHideLeft, this.keyword, this.hintStr})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  void initState() {
    // 语音录入检索
    if (null != widget.keyword) {
      _onEditChange(widget.keyword);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(),
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                  child: ListView.builder(
                      itemCount: searchModel?.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int position) {
                        return _item(position);
                      })))
        ],
      ),
    );
  }

  _item(int position) {
    if (null == searchModel || null == searchModel.data) return null;
    ItemModel model = searchModel.data[position];

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebViewPage(url: model.url, title: '详情')));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(model.type)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(model),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(model),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _subTitle(ItemModel model) {
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: model.price ?? '',
            style: TextStyle(fontSize: 16, color: Colors.orange)),
        TextSpan(
            text: ' ' + (model.star ?? ''),
            style: TextStyle(fontSize: 12, color: Colors.grey)),
      ]),
    );
  }

  _title(ItemModel model) {
    if (null == model) return null;
    List<TextSpan> list = [];
    list.addAll(_keywordTextSpans(model.word, searchModel.keyword));
    list.add(TextSpan(
        text: ' ' + (model.districtname ?? '') + ' ' + (model.zonename ?? ''),
        style: TextStyle(fontSize: 16, color: Colors.grey)));
    return RichText(text: TextSpan(children: list));
  }

  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> list = [];
    if (null == list || word.length == 0) return list;

    // 忽略大小写
    String wordL = word.toLowerCase(), keywordL = keyword.toLowerCase();
    // 根据关键字分割字符内容
    List<String> arr = wordL.split(keywordL);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);

    int preIndex = 0;
    for (int i = 0, k = arr.length; i < k; i++) {
      if (i != 0) {
        // 搜索关键字位置
        preIndex = wordL.indexOf(keywordL, preIndex);
        list.add(TextSpan(
          text: word.substring(preIndex, preIndex + keywordL.length),
          style: keywordStyle,
        ));
      }

      String val = arr[i];
      if (null != val && val.length > 0) {
        list.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return list;
  }

  _typeImage(String type) {
    if (null == type) return "images/type_travelgroup.png";
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  // 渐变遮罩
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              isHideLeft: widget.isHideLeft,
              defaultText: widget.keyword,
              hint: widget.hintStr,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChange: _onEditChange,
            ),
          ),
        )
      ],
    );
  }

  _onEditChange(String text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }

    SearchDao.fetch(keyword).then((SearchModel model) {
      if (model.keyword == keyword) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }
}
