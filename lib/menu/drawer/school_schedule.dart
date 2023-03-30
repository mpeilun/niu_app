import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:niu_app/components/niu_icon_loading.dart';
import 'package:niu_app/components/pdfviwer.dart';

class SchoolSchedule extends StatefulWidget {
  @override
  State<SchoolSchedule> createState() => _SchoolScheduleState();
}

class _SchoolScheduleState extends State<SchoolSchedule> {
  String pdfUrl =
      'https://academic.niu.edu.tw/ezfiles/3/1003/img/41/113854024.pdf';
  Future<bool> getScheduleUrl() async {
    //TODO 自動搜尋行事曆網址
    // Dio dio = new Dio();
    // Response indexRes = await dio
    //     .get("https://www.niu.edu.tw/files/501-1000-1019-1.php?Lang=zh-tw");
    // String indexUrl = parse(indexRes.data)
    //     .body!
    //     .querySelector(
    //         '#Dyn_2_3 > div > div.md_middle > div > div > div > table > tbody > tr:nth-child(2) > td.mc > div > a')!
    //     .attributes
    //     .values
    //     .first;
    // print(indexUrl);
    // Response res = await dio.get(indexUrl);
    // String url = 'http://academic.niu.edu.tw';
    // url += parse(res.data)
    //     .body!
    //     .querySelector(
    //         '#Dyn_2_3 > div.module.module-ptattach.pt_style1 > div.md_middle > div > div > div > table')!
    //     .outerHtml
    //     .split('<span><a href=\"')[1]
    //     .split('\" title=\"')[0];
    // pdfUrl = url;
    // print(pdfUrl);
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getScheduleUrl(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.data == null) {
            return NiuIconLoading(size: 80);
            //return loading widget
          } else {
            return PdfViewer(
              title: '學校行事曆',
              url: pdfUrl,
              showAppbar: false,
            );
          }
        });
  }
}
