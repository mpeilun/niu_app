import 'package:flutter/material.dart';
import 'studentInfo.dart';

class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final StudentID = "B0943014";
    final StudentName = "賴宥蓁";

    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
          backgroundColor: Colors.amber,
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
                          "https://acade.niu.edu.tw/NIU/Application/stdphoto.aspx?stno=" + StudentID ,
                          width: 75,
                          height: 75,
                        ),
                      ),
                    ),
                    Text(
                      StudentName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text('成績'),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('數位學習園區'),

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