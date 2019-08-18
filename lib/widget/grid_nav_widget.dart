import 'package:flutter/material.dart';
import 'package:go_together/model/common_model.dart';
import 'package:go_together/model/grid_nav_model.dart';
import 'package:go_together/pages/web_view_page.dart';

/// 首页类别区域选项
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;
  final String name;

  const GridNav({Key key, @required this.gridNavModel, this.name = 'nav'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 底层Widget编辑
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> list = [];
    if(null == gridNavModel) return null;
    if (gridNavModel.hotel != null) {
      list.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      list.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      list.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return list;
  }

  _gridNavItem(BuildContext context, GridNavChildModel childModel, bool first) {
    List<Widget> list = [];
    list.add(_mainItem(context, childModel.mainItem));
    list.add(_doubleItem(context, childModel.item1, childModel.item2));
    list.add(_doubleItem(context, childModel.item3, childModel.item4));

    List<Widget> expandList = [];
    list.forEach((item) {
      expandList.add(Expanded(
        child: item,
        flex: 1,
      ));
    });

    Color startColor = Color(int.parse('0xff' + childModel.startColor));
    Color endColor = Color(int.parse('0xff' + childModel.endColor));
    return Container(
        height: 88,
        margin: first ? null : EdgeInsets.only(top: 3),
        decoration: BoxDecoration(// 渐变颜色
            gradient: LinearGradient(colors: [startColor, endColor])),
        child: Row(children: expandList));
  }

  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Image.network(
              model.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                model.title,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            )
          ],
        ),
        model);
  }

  _doubleItem(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: <Widget>[
        Expanded(child: _item(context, topItem, true)),
        Expanded(child: _item(context, bottomItem, false))
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool first) {
    BorderSide borderSize = new BorderSide(color: Colors.white, width: 0.8);
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: borderSize,
                bottom: first ? borderSize : BorderSide.none)),
        child: _wrapGesture(
            context,
            Center(
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            item),
      ),
    );
  }

  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
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
      child: widget,
    );
  }
}
