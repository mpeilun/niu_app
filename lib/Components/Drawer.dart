import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
                          "https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2020%2F1216%2Feb2eeb72j00qlf0nn001dd000hs00gap.jpg&thumbnail=650x2147483647&quality=80&type=jpg",
                          width: 80,
                        ),
                      ),
                    ),
                    Text(
                      "小黃",
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