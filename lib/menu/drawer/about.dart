import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 1.0), //陰影y軸偏移量
                  blurRadius: 0, //陰影模糊程度
                  spreadRadius: 0 //陰影擴散程度
                  )
            ],
          ),
          margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Text(
                '開發者',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              'https://img.ltn.com.tw/Upload/ent/page/800/2021/03/28/phpkgbREg.jpg')),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('李知恩'),
                      Text('資工二'),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              'https://img.ltn.com.tw/Upload/ent/page/800/2021/03/28/phpkgbREg.jpg')),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('李知恩'),
                      Text('資工二'),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              'https://img.ltn.com.tw/Upload/ent/page/800/2021/03/28/phpkgbREg.jpg')),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('李知恩'),
                      Text('資工二'),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              'https://img.ltn.com.tw/Upload/ent/page/800/2021/03/28/phpkgbREg.jpg')),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('李知恩'),
                      Text('資工二'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
