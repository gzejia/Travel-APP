import 'package:flutter/material.dart';

enum SearchBarType {
  home, // 首页底部透明
  normal, // 检索页
  homeLight // 首页底部高亮
}

/// 搜索框
class SearchBar extends StatefulWidget {
  final bool isEnabled;
  final bool isHideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChange;

  const SearchBar(
      {Key key,
      this.isEnabled,
      this.isHideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChange})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool isShowClear = false;

  TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        // 检索框默认提示内容
        _editController.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _getNormalSearch()
        : _getHomeSearch();
  }

  _getNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
                child: widget?.isHideLeft ?? false
                    ? null
                    : Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                        size: 26,
                      ),
              ),
              widget?.leftButtonClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          )
        ],
      ),
    );
  }

  _getHomeSearch() {
    Color _homeFontColor = widget?.searchBarType == SearchBarType.homeLight
        ? Colors.black45
        : Colors.white;

    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                child: Row(
                  children: <Widget>[
                    Text('广州',
                        style: TextStyle(color: _homeFontColor, fontSize: 14)),
                    Icon(
                      Icons.expand_more,
                      color: _homeFontColor,
                      size: 22,
                    )
                  ],
                ),
              ),
              widget.leftButtonClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(
                  Icons.comment,
                  color: _homeFontColor,
                  size: 26,
                ),
              ),
              widget.rightButtonClick)
        ],
      ),
    );
  }

  _inputBox() {
    final bool isHomeSearch = widget?.searchBarType == SearchBarType.home;
    final bool isNormalSearch = widget?.searchBarType == SearchBarType.normal;
    // 编辑框圆角大小
    final double borderRadius = isHomeSearch ? 5 : 15;
    // 编辑框主题色
    Color inputBoxColor =
        isHomeSearch ? Colors.white : Color(int.parse('0xffEDEDED'));
    // 检索Icon颜色
    Color searchIconColor =
        isNormalSearch ? Colors.blue : Color(int.parse('0xffA9A9A9'));

    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, size: 20, color: searchIconColor),
          Expanded(
            flex: 1,
            child: isNormalSearch
                ? TextField(
                    controller: _editController,
                    onChanged: _editChanged,
                    autofocus: true,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    // 输入文本样式
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        border: InputBorder.none,
                        hintText: widget.hint ?? '',
                        hintStyle: TextStyle(fontSize: 15)),
                  )
                : _wrapTap(
                    Container(
                      child: Text(widget.defaultText,
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ),
                    widget.inputBoxClick),
          ),
          !isShowClear
              ? _wrapTap(Icon(Icons.mic, size: 22, color: searchIconColor),
                  widget.speakClick)
              : _wrapTap(Icon(Icons.clear, size: 22, color: Colors.grey), () {
                  setState(() {
                    _editController.clear();
                  });

                  _editChanged('');
                })
        ],
      ),
    );
  }

  _editChanged(String text) {
    if (text.length > 0) {
      setState(() {
        isShowClear = true;
      });
    } else {
      setState(() {
        isShowClear = false;
      });
    }

    if (null != widget?.onChange ?? null) {
      widget.onChange(text);
    }
  }

  _wrapTap(Widget child, void Function() callBack) {
    return GestureDetector(
      onTap: () {
        if (callBack != null) callBack();
      },
      child: child,
    );
  }
}
