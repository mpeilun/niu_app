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
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(0, 70, 161, 1),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 38.0),
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}