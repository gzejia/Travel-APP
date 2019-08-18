import 'package:flutter/material.dart';
import 'navigator/tab_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '一起GO',
      theme: ThemeData(
          primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    );
  }
}
