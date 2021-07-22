import 'package:flutter/material.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLargeScreen=false; //是否是大螢幕

  var selectValue = 0; //儲存選擇的內容

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new OrientationBuilder(builder: (context, orientation) {
        print("width:${MediaQuery.of(context).size.width}");
        //判斷螢幕寬度
        if (MediaQuery.of(context).size.width > 600) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }
        //兩個widget是放在一個Row中進行顯示，如果是小螢幕的話，用一個空的Container進行佔位
        //如果是大螢幕的話，則用Expanded進行螢幕的劃分並顯示詳細檢視
        return new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Expanded(child: new ListWidget(
              itemSelectedCallback: (value) {
                //定義列表項的點選回撥
                if (isLargeScreen) {
                  selectValue = value;
                  setState(() {});
                } else {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return new DetailWidget(value);
                  }));
                }
              },
            )),
            isLargeScreen
                ? new Expanded(child: new DetailWidget(selectValue))
                : new Container()
          ],
        );
      }),
    );
  }
}

class DetailWidget extends StatelessWidget {
  final int data;

  DetailWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: new Center(
          child: new Text("詳細檢視:$data"),
        ),
      ),
    );
  }
}
//需要定義一個回撥，決定是在同一個螢幕上顯示更改詳細檢視還是在較小的螢幕上導航到不同介面。
typedef Null ItemSelectedCallback(int value);
//列表的Widget
class ListWidget extends StatelessWidget {
  final ItemSelectedCallback itemSelectedCallback;

  ListWidget({required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text("$index"),
            onTap: () {
              //設定點選事件
              this.itemSelectedCallback(index);
            },
          );
        });
  }
}