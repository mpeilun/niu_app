import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Event {
  final String name;
  final String department;
  final String signTimeStart;
  final String signTimeEnd;
  final String eventTimeStart;
  final String eventTimeEnd;
  final String status;

  Event({
    required this.name,
    required this.department,
    required this.signTimeStart,
    required this.signTimeEnd,
    required this.eventTimeStart,
    required this.eventTimeEnd,
    required this.status,
  });
}
class EventSigned {
  final String name;
  final String department;

  EventSigned({
    required this.name,
    required this.department,
  });
}

class Quote {
  final String lesson;
  final double score;
  final String? teacher;

  Quote({
    required this.lesson,
    required this.score,
    String? teacher,
  }) : this.teacher = teacher;
}

final List<Quote> grades2 = [
  Quote(
    lesson: '課程99',
    score: 80.0,
    teacher: 'star',
  ),
  Quote(
    lesson: '課程88',
    score: 85.0,
    teacher: 'AA',
  ),
  Quote(
    lesson: '課程77',
    score: 75.0,
    teacher: 'rock',
  ),
  Quote(
    lesson: '課程66',
    score: 65.0,
  ),
  Quote(
    lesson: '課程55',
    score: 95.0,
    teacher: 'BB',
  ),
  Quote(
    lesson: '課程44',
    score: 95.0,
    teacher: 'CC',
  ),
  Quote(
    lesson: '課程33',
    score: 95.0,
  ),
  Quote(
    lesson: '課程22',
    score: 95.0,
    teacher: 'gas',
  ),
  Quote(
    lesson: '課程11',
    score: 95.0,
  ),
  Quote(
    lesson: '課程00',
    score: 95.0,
  ),
];

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
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1.5,
        indent: 12,
        endIndent: 10,
      ),
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: (){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(index.toString())));
        },
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 4.0, 14.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenSizeWidth*0.6,
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
                      width: screenSizeWidth*0.3,
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
                margin: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('測試')
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

class CustomEventSignedCard extends StatelessWidget {
  final List<Quote> data;

  const CustomEventSignedCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) => Card(
        elevation: 1.5,
        margin: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 4.0),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ListTile(
            title: Row(
              children: [
                Text(
                  data[index].lesson,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            subtitle: Text(
              '分數：${data[index].score}',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
