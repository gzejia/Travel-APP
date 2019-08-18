import 'package:flutter/material.dart';
import 'package:go_together/pages/home_page.dart';
import 'package:go_together/pages/my_page.dart';
import 'package:go_together/pages/search_page.dart';
import 'package:go_together/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _selectIndex = 0;

  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          HomePage(),
          SearchPage(),
          TravelPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: (BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectIndex,
          onTap: (index) {
            _pageController.jumpToPage(index);
            setState(() {
              _selectIndex = index;
            });
          },
          items: [
            _navItem(Icons.home, '首页', 0),
            _navItem(Icons.search, '检索', 1),
            _navItem(Icons.camera_alt, '旅拍', 2),
            _navItem(Icons.person, '我的', 3),
          ])),
    );
  }

  // 获取底部导航栏的每个Tab
  BottomNavigationBarItem _navItem(IconData icon, String name, int index) {
    final _defaultColor = Colors.grey;
    final _selectColor = Colors.blue;

    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _selectColor,
        ),
        title: Text(
          name,
          style: TextStyle(
              color: _selectIndex == index ? _selectColor : _defaultColor),
        ));
  }
}
