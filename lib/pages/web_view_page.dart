import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

/// url访问页
class WebViewPage extends StatefulWidget {
  String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  WebViewPage(
      {this.url,
      this.statusBarColor = 'ffffff',
      this.title,
      this.hideAppBar,
      this.backForbid = false}) {
    if (null != null && url.contains('ctrip.com')) {
      // 解决http访问失败问题
      url = url.replaceAll("http://", "https://");
    }
  }

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final webViewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;

  // 是否为白名单URL
  _is2Main(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void initState() {
    super.initState();

    // 避免重新加载
    webViewReference.close();

    // 加载地址监听
    _onUrlChanged = webViewReference.onUrlChanged.listen((String url) {});

    // 加载状态监听
    _onStateChanged =
        webViewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
          if (_is2Main(state.url) && !exiting) {
            if (widget.backForbid) {
              webViewReference.launch(widget.url);
            } else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;

        default:
          break;
      }
    });

    // 加载异常监听
    _onHttpError =
        webViewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    webViewReference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 背景色，String转16禁止
    Color backgroundColor = Color(int.parse('0xff' + widget.statusBarColor));
    // 字体颜色
    Color backButtonColor =
        widget.statusBarColor == 'ffffff' ? Colors.black : Colors.white;

    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(backgroundColor, backButtonColor),
          Expanded(
              child: WebviewScaffold(
            userAgent: 'null',
            // 防止携程H5页面重定向到打开携程APP ctrip://wireless/xxx的网址
            url: widget.url,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.white,
              child: Center(child: Text('Waiting...')),
            ),
          ))
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    // 是否隐藏了标题栏
    if (widget.hideAppBar ?? false) {
      // 只显示状态栏
      return Container(color: backgroundColor, height: 24);
    }

    return Container(
      color: backButtonColor,
      padding: EdgeInsets.only(top: 24),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close, size: 26, color: backButtonColor)),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                  child: Text(widget.title ?? '',
                      style: TextStyle(color: backButtonColor, fontSize: 20))),
            )
          ],
        ),
      ),
    );
  }
}
