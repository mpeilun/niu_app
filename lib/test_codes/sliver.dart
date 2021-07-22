import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  SystemUiOverlayStyle style = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(style);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData( primarySwatch: Colors.blue  ),
        home: Scaffold(
          body: SliverPersistentHeaderDemo(),
        ));
  }
}

class SliverPersistentHeaderDemo extends StatelessWidget {
  // 色彩数据
  final List<Color> data = List.generate(24, (i) => Color(0xFFFF00FF - 24*i));

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildSliverList()
      ],
    );
  }

  // 构建颜色列表
  Widget _buildSliverList() =>
      SliverList(
        delegate: SliverChildBuilderDelegate(
                (_, int index) => _buildColorItem(data[index]),
            childCount: data.length),
      );

  // 构建颜色列表item
  Widget _buildColorItem(Color color) =>
      Card(
        child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 60,
          color: color,
          child: Text(
            colorString(color),
            style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black,
                      offset: Offset(.5, .5),
                      blurRadius: 2)
                ]),
          ),
        ),
      );

  // 颜色转换为文字
  String colorString(Color color) =>
      "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
}

