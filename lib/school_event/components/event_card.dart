import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:niu_app/school_event/dialog/event_info_dialog.dart';
import 'package:niu_app/school_event/school_event.dart';

import 'custom_list_info.dart';

class Event {
  final String name;
  final String department;
  final String signTimeStart;
  final String signTimeEnd;
  final String eventTimeStart;
  final String eventTimeEnd;
  final String status;
  final String positive;
  final String positiveLimit;
  final String wait;
  final String waitLimit;
  final String signUpJS;

  Event({
    required this.name,
    required this.department,
    required this.signTimeStart,
    required this.signTimeEnd,
    required this.eventTimeStart,
    required this.eventTimeEnd,
    required this.status,
    required this.positive,
    required this.positiveLimit,
    required this.wait,
    required this.waitLimit,
    required this.signUpJS,
  });
}

class CustomEventCard extends StatefulWidget {
  final List<Event> data;

  const CustomEventCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _CustomEventCardState createState() => _CustomEventCardState();
}

class _CustomEventCardState extends State<CustomEventCard> {
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
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(
                      widget.data[index].name,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSizeWidth * 0.05,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      widget.data[index].department,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
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
                key: PageStorageKey('event' + index.toString()),
                title: Text(
                  '　詳細資料',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Column(
                    children: [
                      ListInfo(
                        icon: Icons.info,
                        title: '活動狀態',
                        widget: Text(widget.data[index].status,
                            style: TextStyle(fontSize: 14)),
                      ),
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
                        widget: Column(
                          children: [
                            Text(
                              widget.data[index].signTimeStart + '起',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              widget.data[index].signTimeEnd + '止',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      ListInfo(
                        icon: Icons.groups,
                        title: '報名人數',
                        widget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '正取: ' +
                                  widget.data[index].positive +
                                  '/' +
                                  widget.data[index].positiveLimit +
                                  '人',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              '備取: ' +
                                  widget.data[index].wait +
                                  '/' +
                                  widget.data[index].waitLimit +
                                  '人',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      (widget.data[index].status == "報名中" ||
                              widget.data[index].status == "已額滿")
                          ? ElevatedButton(
                              onPressed: () {
                                print(widget.data[index].signUpJS);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => EventInfoDialog(eventJS: widget.data[index].signUpJS),
                                );
                              },
                              child: Text('我要報名'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                final scaffold = ScaffoldMessenger.of(context);
                                final snackBar = SnackBar(
                                  content: Text(widget.data[index].status + ' 無法報名'),
                                  action: SnackBarAction(
                                    label: '確定',
                                    onPressed: () {
                                      scaffold.removeCurrentSnackBar();
                                    },
                                  ),
                                );
                                scaffold.showSnackBar(snackBar);
                              },
                              child: Text('不可報名'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(Colors.grey)
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
