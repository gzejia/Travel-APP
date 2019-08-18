import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:go_together/dao/home_dao.dart';
import 'package:go_together/model/common_model.dart';
import 'package:go_together/model/grid_nav_model.dart';
import 'package:go_together/model/sales_box_model.dart';
import 'dart:convert';

import 'package:go_together/widget/grid_nav_widget.dart';
import 'package:go_together/widget/local_nav_widget.dart';
import 'package:go_together/widget/sales_nav_widget.dart';
import 'package:go_together/widget/sub_nav_widget.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBox;

  String _resultJson = '';

  final List<String> _bannerUrls = [
    'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3300305952,1328708913&fm=27&gp=0.jpg',
    'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1718395925,3485808025&fm=27&gp=0.jpg',
    'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1080760116,732088640&fm=27&gp=0.jpg',
    'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2509469443,1652062333&fm=27&gp=0.jpg'
  ];
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
    _loadData();
  }

  _loadData() async {
    HomeDao.fetch().then((result) {
      setState(() {
        _resultJson = json.encode(result.config);
        localNavList = result.localNavList;
        subNavList = result.subNavList;
        gridNavModel = result.gridNav;
        salesBox = result.salesBox;
      });
    }).catchError((e) {
      setState(() {
        _resultJson = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.depth == 0) {
                    // 滚动且是列表滚动的时候
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                },
                child: _listView,
              )),
          _appBar,
        ],
      ),
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
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('首页'),
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
        itemCount: _bannerUrls.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Image.network(
              _bannerUrls[index],
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
        Container(
          height: 160,
          alignment: Alignment.center,
          child: Text('4'),
        ),
        Container(
          height: 160,
          alignment: Alignment.center,
          child: Text('5'),
        )
      ],
    );
  }
}
