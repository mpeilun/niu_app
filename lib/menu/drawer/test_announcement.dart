import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';

import 'package:niu_app/components/niu_icon_loading.dart';

class TestAnnouncementPage extends StatefulWidget {
  @override
  State<TestAnnouncementPage> createState() => _TestAnnouncementPageState();
}

class _TestAnnouncementPageState extends State<TestAnnouncementPage> {
  List contents = [];
  List<String> links = [];
  Future<bool> isFinish() async{
    await getPost(1);
    return true;
  }
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: isFinish(), // the function to get your data from firebase or firestore
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.data == null) {
            return NiuIconLoading(size: 80);
            //return loading widget
          } else {
            return Center(
                child: ListView.builder(
                  itemCount: contents.length,
                  itemBuilder: (context, index) {
                    var item = contents[index];
                    return ListTile(
                      //leading: Icon(Icons.event_seat),
                      title: Text(item.text.replaceAll("\n","").replaceAll(" ","")),
                      onTap: (){

                      },
                      //subtitle: Text('${content[index].price}'),
                    );
                  },
                )
            );
          }
        });
  }

  Future<void> getPost(int page) async{
    Dio dio = new Dio();
    Response res = await dio.get("https://www.niu.edu.tw/files/501-1000-1019-$page.php?Lang=zh-tw");
    var document = parse(res.data);
    var tempList = document.getElementsByClassName("h5");//print(tempList[i].text.replaceAll("\n","")  =>   [ 2021-07-26  ] 【公告】本校110學年度教務處行事曆
    tempList.removeRange(0,8);
    contents.addAll(tempList);
    for(var content in contents){
      if(content.children[1].attributes['href'][0].toString()==("/")){
        links.add("https://academic.niu.edu.tw${content.children[1].attributes['href']}");
      }
      else{
        links.add(content.children[1].attributes['href']);
      }
    }
  }
}