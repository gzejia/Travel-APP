import 'package:flutter/material.dart';
import 'package:go_together/model/common_model.dart';
import 'package:go_together/pages/web_view_page.dart';

/// 首页活动区表格选项
class LocalNav extends StatelessWidget {
  final List<CommonModel> commonModels;
  final String name;

  const LocalNav({Key key, @required this.commonModels, this.name = 'nav'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _items(context),
      ),
    );
  }

  List<Widget> _items(BuildContext context) {
    if (null == commonModels) return null;

    List<Widget> localNavList = [];
    commonModels.forEach((model) {
      localNavList.add(_item(context, model));
    });

    return localNavList;
  }

  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPage(
                    url: model.url,
                    title: model.title,
                    statusBarColor: model.statusBarColor,
                    hideAppBar: model.hideAppBar)));
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Image.network(model.icon, width: 40, height: 40),
            Text(model.title,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14))
          ],
        ),
      ),
    );
  }
}
