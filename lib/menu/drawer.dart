import 'package:flutter/material.dart';
import './studentInfo.dart';

class MyDrawer extends StatefulWidget {
  final StudentInfo info;
  MyDrawer({Key? key,required this.info}) : super(key: key);

  @override
  _MyDrawer createState() => new _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {

  @override
  Widget build(BuildContext context) {

    final studentID = widget.info.ID;
    final studentName = widget.info.name;

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ClipOval(
                          child: Image.network(
                            "https://acade.niu.edu.tw/NIU/Application/stdphoto.aspx?stno=" + studentID ,
                            width: 75,
                            height: 75,
                          ),
                        ),
                      ),
                      Text(
                        studentName,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                            Icons.turned_in_not,
                            color: Colors.black
                        ),//暫時找不到
                        title: Text(
                            '公告',
                            style: TextStyle(color: Colors.black),
                        ),
                        onTap: (){},
                      ),
                      ListTile(
                        leading: Icon(
                            Icons.settings,
                            color: Colors.black
                        ),
                        title: Text(
                            '設定',
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: (){},
                      ),
                      ListTile(
                        leading: Icon(
                            Icons.info,
                            color: Colors.black
                        ),
                        title: Text(
                            '關於',
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: (){},
                      ),
                      ListTile(
                        leading: Icon(
                            Icons.logout,
                            color: Colors.black
                        ),
                        title: Text(
                            '登出',
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: (){},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}