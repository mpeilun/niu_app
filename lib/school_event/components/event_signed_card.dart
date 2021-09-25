import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:niu_app/school_event/dialog/event_info_dialog.dart';

import 'custom_list_info.dart';
import '../school_event.dart';

class EventSigned {
  final String name;
  final String status;
  final String signedStatus;
  final String signTime;
  final String eventTimeStart;
  final String eventTimeEnd;

  EventSigned({
    required this.name,
    required this.status,
    required this.signTime,
    required this.eventTimeStart,
    required this.eventTimeEnd,
    required this.signedStatus,
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
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1.5,
        indent: 12,
        endIndent: 10,
      ),
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(index.toString())));
          showListDialog();
        },
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(screenSizeWidth * 0.05,
                    screenSizeHeight * 0.01, screenSizeWidth * 0.05, 0.0),
                child: Text(
                  widget.data[index].name,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1.5,
                margin: EdgeInsets.fromLTRB(
                    screenSizeWidth * 0.05,
                    screenSizeHeight * 0.005,
                    screenSizeWidth * 0.05,
                    screenSizeHeight * 0.01),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showListDialog() async {
    int? index = await showDialog<int>(
      context: context,
      builder: (BuildContext context) => Dialog(child: EventInfoDialog()),
    );
    if (index != null) {
      print("點了：$index");
    }
  }
}