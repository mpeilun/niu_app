import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/pdfviwer.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../provider/dark_mode_provider.dart';

class SchoolSchedule extends StatefulWidget {
  @override
  State<SchoolSchedule> createState() => _SchoolScheduleState();
}

class _SchoolScheduleState extends State<SchoolSchedule> {
  List pdfList = [];
  String baseURL = "https://academic-r.niu.edu.tw";
  String pdfUrl =
      'https://academic.niu.edu.tw/ezfiles/3/1003/img/41/113854024.pdf';
  String dropdownValue = "";
  bool standby = false;

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Future<bool> getScheduleUrl() async {
    //TODO 自動搜尋行事曆網址
    //https://academic-r.niu.edu.tw/ezfiles/3/1003/img/41/113854024.pdf
    pdfList.clear();
    Dio dio = new Dio();
    Response indexRes =
        await dio.get("https://academic-r.niu.edu.tw/files/11-1003-446.php");
    var rawData = parse(indexRes.data)
        .body!
        .querySelector(
            '#Dyn_2_3 > div.module.module-sublist > div.md_middle > div > div > div > table > tbody')!
        .children;
    // String indexUrl = parse(indexRes.data)
    //     .body!
    //     .querySelector(
    //     '#Dyn_2_3 > div > div.md_middle > div > div > div > table > tbody > tr:nth-child(2) > td.mc > div > a')!
    //     .attributes
    //     .values
    //     .first;
    for (int i = 1; i < rawData.length - 1; i = i + 3) {
      var filename = rawData[i]
          .children[1]
          .getElementsByTagName("a")[0]
          .outerHtml
          .split("title=\"")[1]
          .split("\"")[0];
      // print(filename);
      var link = rawData[i]
          .children[1]
          .getElementsByTagName("a")[0]
          .outerHtml
          .split('href=\"')[1]
          .split('\"')[0];
      print({'filename': filename, 'link': link});
      pdfList.add({'filename': filename, 'link': baseURL + link});
      // print(pdfList);
    }
    // print("I'm here.");
    this.dropdownValue = pdfList.first['filename'];
    setState(() {
      this.standby = true;
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
    getScheduleUrl();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return standby
        ? Stack(
            children: [
              PdfViewer(
                title: dropdownValue,
                url: pdfList.firstWhere(
                    (element) => element['filename'] == dropdownValue)['link'],
                showAppbar: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: themeChange.darkTheme
                          ? Theme.of(context).cardColor
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                            color: themeChange.darkTheme
                                ? Colors.transparent
                                : Colors.grey,
                            offset: Offset(1.0, 1.0), //陰影y軸偏移量
                            blurRadius: 0, //陰影模糊程度
                            spreadRadius: 0 //陰影擴散程度
                        )
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: pdfList.map<DropdownMenuItem<String>>((var element) {
                        return DropdownMenuItem<String>(
                          value: element['filename'],
                          child: Text(element['filename']),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          )
        : NiuIconLoading(size: 80);
    // return FutureBuilder(
    //     future: getScheduleUrl(),
    //     builder: (BuildContext context, AsyncSnapshot snap) {
    //       if (snap.data == null) {
    //         return NiuIconLoading(size: 80);
    //         //return loading widget
    //       } else {
    //         return PdfViewer(
    //           title: '學校行事曆',
    //           url: pdfUrl,
    //           showAppbar: false,
    //         );
    //       }
    //     });
  }
}
