import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  });
}

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
  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: widget.data.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(index.toString())));
        },
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(screenSizeWidth*0.05, screenSizeHeight*0.01, screenSizeWidth*0.05, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenSizeWidth * 0.6,
                      child: Text(
                        widget.data[index].name,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: screenSizeWidth * 0.3,
                      child: Text(
                        '${widget.data[index].department}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1.5,
                margin: EdgeInsets.fromLTRB(screenSizeWidth*0.05, screenSizeHeight*0.005, screenSizeWidth*0.05, screenSizeHeight*0.01),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListInfo(
                        icon: Icons.info,
                        title: '活動狀態',
                        widget: Text(widget.data[index].status
                            ,
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
                            Text(widget.data[index].eventTimeEnd + '止',
                              style: TextStyle(fontSize: 14),),
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
                            Text(widget.data[index].signTimeEnd + '止',
                              style: TextStyle(fontSize: 14),),
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
                              '正取: ' +widget.data[index].positive +'/'+ widget.data[index].positiveLimit + '人',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              '備取: ' +widget.data[index].wait +'/'+ widget.data[index].waitLimit + '人',
                              style: TextStyle(fontSize: 14),),
                          ],
                        ),
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
  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: widget.data.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1.5,
        indent: 12,
        endIndent: 10,
      ),
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(index.toString())));
        },
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(screenSizeWidth*0.05, screenSizeHeight*0.01, screenSizeWidth*0.05, 0.0),
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
                margin: EdgeInsets.fromLTRB(screenSizeWidth*0.05, screenSizeHeight*0.005, screenSizeWidth*0.05, screenSizeHeight*0.01),
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
                            Text(widget.data[index].eventTimeEnd + '止',
                              style: TextStyle(fontSize: 14),),
                          ],
                        ),
                      ),
                      ListInfo(
                        icon: Icons.access_time,
                        title: '報名時間',
                        widget: Text(widget.data[index].signTime
                            ,
                            style: TextStyle(fontSize: 14)),
                      ),
                      ListInfo(
                        icon: Icons.done_all,
                        title: '報名狀態',
                        widget: Text(widget.data[index].signedStatus
                            ,
                            style: TextStyle(fontSize: 14)),
                      ),
                      ListInfo(
                        icon: Icons.info,
                        title: '活動狀態',
                        widget: Text(widget.data[index].status
                            ,
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
}

class ListInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget widget;

  ListInfo({
    required this.icon,
    required this.title,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon),
                    SizedBox(
                      width: screenSizeWidth * 0.01,
                    ),
                    Text(title),
                  ],
                ),
                flex: 2,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
