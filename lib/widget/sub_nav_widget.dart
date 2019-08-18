import 'package:flutter/material.dart';
import 'package:go_together/model/common_model.dart';
import 'package:go_together/pages/web_view_page.dart';

/// 首页服务区选项
class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;
  final String name;

  const SubNav({Key key, @required this.subNavList, this.name = 'nav'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (subNavList == null) return null;

    List<Widget> items = [];
    subNavList.forEach((item) {
      items.add(_item(context, item));
    });

    //计算出第一行显示的数量
    int separate = (subNavList.length / 2 + 0.5).toInt();

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0, separate),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(separate, items.length),
        ),
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewPage(
                      url: model.url,
                      title: model.title)));
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Image.network(model.icon, width: 18, height: 18),
              Text(model.title,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14))
            ],
          ),
        ),
      ),
    );
  }
}
