import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:go_together/dao/home_dao.dart';
import 'package:go_together/model/common_model.dart';
import 'package:go_together/model/grid_nav_model.dart';
import 'package:go_together/model/sales_box_model.dart';
import 'package:go_together/pages/search_page.dart';

import 'package:go_together/widget/grid_nav_widget.dart';
import 'package:go_together/widget/loading_container.dart';
import 'package:go_together/widget/local_nav_widget.dart';
import 'package:go_together/widget/sales_nav_widget.dart';
import 'package:go_together/widget/search_bar.dart';
import 'package:go_together/widget/sub_nav_widget.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBox;

  // 加载状态
  bool _loading = true;

  // 标题栏透明度
  double appBarAlpha = 0;

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;

    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }

    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<Null> _handleRefresh() async {
    HomeDao.fetch().then((result) {
      setState(() {
        localNavList = result.localNavList;
        subNavList = result.subNavList;
        gridNavModel = result.gridNav;
        salesBox = result.salesBox;
        bannerList = result.bannerList;

        _loading = false;
      });
    }).catchError((e) {
      print(e);

      setState(() {
        _loading = false;
      });
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: NotificationListener(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification &&
                              scrollNotification.depth == 0) {
                            // 滚动且是列表滚动的时候
                            _onScroll(scrollNotification.metrics.pixels);
                          }
                        },
                        child: _listView,
                      ))),
              _appBar,
            ],
          )),
    );
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: '网红打卡地 景点 酒店 美食',
              leftButtonClick: () {},
            ),
          ),
        )
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Container(
            child: LocalNav(commonModels: localNavList),
            padding: EdgeInsets.fromLTRB(5, 4, 5, 4)),
        Container(
          child: GridNav(gridNavModel: gridNavModel),
          padding: EdgeInsets.fromLTRB(5, 0, 5, 4),
        ),
        Container(
          child: SubNav(subNavList: subNavList),
          padding: EdgeInsets.fromLTRB(5, 0, 5, 4),
        ),
        Container(
          child: SalesNav(salesBox: salesBox),
        ),
      ],
    );
  }

  _jumpToSearch() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchPage(hintStr: '网红打卡地 景点 酒店 美食')));
  }

  _jumpToSpeak() {}
}
