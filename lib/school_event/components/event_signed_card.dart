import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:niu_app/school_event/dialog/event_info_dialog.dart';
import 'package:niu_app/school_event/dialog/event_signed_info_dialog.dart';

import 'custom_list_info.dart';
import '../school_event.dart';

class EventSigned {
  final String name;
  final String status;
  final String signedStatus;
  final String signTime;
  final String eventTimeStart;
  final String eventTimeEnd;
  final String js;

  EventSigned({
    required this.name,
    required this.status,
    required this.signTime,
    required this.eventTimeStart,
    required this.eventTimeEnd,
    required this.signedStatus,
    required this.js,
  });
}

class CustomEventSignedCard extends StatefulWidget {
  final List<EventSigned> data;

  const CustomEventSignedCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _CustomEventSignedCardState createState() => _CustomEventSignedCardState();
}

class _CustomEventSignedCardState extends State<CustomEventSignedCard> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      schoolEventScrollController.jumpTo(_scrollController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.data.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) => Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(screenSizeWidth * 0.05,
                screenSizeHeight * 0.01, screenSizeWidth * 0.05, 0.0),
            child: Text(
              widget.data[index].name,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              // color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    // color: Colors.grey,
                    offset: Offset(1.0, 1.0), //陰影y軸偏移量
                    blurRadius: 0, //陰影模糊程度
                    spreadRadius: 0 //陰影擴散程度
                )
              ],
            ),
            margin: EdgeInsets.fromLTRB(
                screenSizeWidth * 0.05,
                screenSizeHeight * 0.01,
                screenSizeWidth * 0.05,
                screenSizeHeight * 0.01),
            child: Theme(
              data: Theme.of(context).copyWith(
                accentColor: Colors.black,
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                key: PageStorageKey('event_signed' + index.toString()),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: screenSizeWidth*0.04,),
                    Text(
                      '詳細資料',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: SizedBox()),
                    Container(
                        height: 25.0,
                        width: 55.0,
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0,
                              color: widget.data[index].status == '未開始'
                                  ? Color(0xff2364aa)
                                  : Color(0xFF954242)),
                          borderRadius: BorderRadius.all(Radius.circular(
                              10.0) //         <--- border radius here
                          ),
                        ),
                        child: Text(
                          widget.data[index].status,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: widget.data[index].status == '未開始'
                                ? Color(0xff2364aa)
                                : Color(0xFF954242),
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ],
                ),
                children: [
                  Column(
                    children: [
                      ListInfo(
                        icon: Icons.calendar_today,
                        title: '活動時間',
                        widget: Column(
                          children: [
                            Text(
                              widget.data[index].eventTimeStart + '起',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              widget.data[index].eventTimeEnd + '止',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      ListInfo(
                        icon: Icons.access_time,
                        title: '報名時間',
                        widget: Text(widget.data[index].signTime,
                            style: TextStyle(fontSize: 14)),
                      ),
                      ListInfo(
                        icon: Icons.done_all,
                        title: '報名狀態',
                        widget: Text(widget.data[index].signedStatus,
                            style: TextStyle(fontSize: 14)),
                      ),
                      ListInfo(
                        icon: Icons.info,
                        title: '活動狀態',
                        widget: Text(widget.data[index].status,
                            style: TextStyle(fontSize: 14)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(widget.data[index].js);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => EventSignedInfoDialog(
                              js: widget.data[index].js,
                            ),
                          );
                        },
                        child: Text('詳細'),
                        style: ButtonStyle(
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSizeHeight * 0.015,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
