import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:niu_app/school_event/dialog/event_info_dialog.dart';
import 'package:niu_app/school_event/school_event.dart';
import 'package:provider/provider.dart';

import 'anim_search.dart';
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
  final String eventSerialNum;

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
    required this.eventSerialNum,
  });
}

class CustomEventCard extends StatefulWidget {
  final List<dynamic> data;
  final List<dynamic> dataCanSignUp;
  final List<dynamic> dataUnable;

  const CustomEventCard({
    Key? key,
    required this.data,
    required this.dataCanSignUp,
    required this.dataUnable,
  }) : super(key: key);

  @override
  _CustomEventCardState createState() => _CustomEventCardState();
}

class _CustomEventCardState extends State<CustomEventCard> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  List<bool> _isSelected = [true, false, false];
  late List<dynamic> display = widget.data;
  List<Event> tmp = [];

  void search() {
    tmp.clear();
    setState(() {
      _isSelected = [true, false, false];
    });
    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i].name
              .toLowerCase()
              .contains(_textEditingController.text.toLowerCase()) ||
          widget.data[i].eventSerialNum.contains(_textEditingController.text))
        tmp.add(widget.data[i]);
    }
    setState(() {
      display = tmp;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      schoolEventScrollController.jumpTo(_scrollController.offset);
    });
    _textEditingController.addListener(search);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 30.0,
              child: ToggleButtons(
                disabledColor: Color(0xffbbbbbb),
                borderWidth: 2.0,
                selectedColor: Colors.white,
                selectedBorderColor: Theme.of(context).primaryColor,
                fillColor: Theme.of(context).primaryColor,
                // selectedBorderColor: Colors.blue[900],
                // fillColor: Colors.blue[900],
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                children: <Widget>[
                  Container(
                    child: Text(
                      '所有活動',
                      textAlign: TextAlign.center,
                    ),
                    width: screenSizeWidth * 0.3,
                  ),
                  Container(
                    child: Text('可報名的', textAlign: TextAlign.center),
                    width: screenSizeWidth * 0.3,
                  ),
                  Container(
                    child: Text('不可報名', textAlign: TextAlign.center),
                    width: screenSizeWidth * 0.3,
                  ),
                ],
                isSelected: _isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _isSelected.length; i++) {
                      if (i == index)
                        _isSelected[i] = true;
                      else
                        _isSelected[i] = false;
                    }
                    switch (index) {
                      case 0:
                        display = widget.data;
                        break;
                      case 1:
                        display = widget.dataCanSignUp;
                        break;
                      case 2:
                        display = widget.dataUnable;
                        break;
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: display.length,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  thickness: 1.5,
                  indent: 10,
                  endIndent: 10,
                ),
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
                                display[index]['name'],
                                style: TextStyle(
                                    fontSize: 16.0,
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
                                display[index]['department'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: themeChange.darkTheme
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
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
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenSizeWidth * 0.04,
                              ),
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
                                      color: themeChange.darkTheme
                                          ? display[index]['state'] == '報名中'
                                              ? Color(0xff1E88E5)
                                              : Color(0xffE53935)
                                          : display[index]['state'] == '報名中'
                                              ? Color(0xff2364aa)
                                              : Color(0xFF954242),
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            10.0) //         <--- border radius here
                                        ),
                                  ),
                                  child: Text(
                                    display[index]['state'],
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: themeChange.darkTheme
                                          ? display[index]['state'] == '報名中'
                                              ? Color(0xff1E88E5)
                                              : Color(0xffE53935)
                                          : display[index]['state'] == '報名中'
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
                                  icon: Icons.info,
                                  title: '活動編號',
                                  widget: Text(display[index]['eventSerialNum'],
                                      style: TextStyle(fontSize: 14)),
                                ),
                                ListInfo(
                                  icon: Icons.calendar_today,
                                  title: '活動時間',
                                  widget: Column(
                                    children: [
                                      Text(
                                        display[index]['eventTimeStart'] + '起',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        display[index]['eventTimeEnd'] + '止',
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
                                        display[index]['signTimeStart'] + '起',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        display[index]['signTimeEnd'] + '止',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                ListInfo(
                                  icon: Icons.groups,
                                  title: '報名人數',
                                  widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '正取: ' +
                                            display[index]['positive'] +
                                            '/' +
                                            display[index]['positiveLimit'] +
                                            '人',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '備取: ' +
                                            display[index]['wait'] +
                                            '/' +
                                            display[index]['waitLimit'] +
                                            '人',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                display[index]['state'] == "報名中"
                                    ? ElevatedButton(
                                        onPressed: () {
                                          print(display[index]['signUpJs']);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                EventInfoDialog(
                                                    eventJS: display[index]
                                                        ['signUpJs']),
                                          );
                                        },
                                        child: Text('我要報名'),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                          ),
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {
                                          showToast('無法報名');
                                        },
                                        child: Text('不可報名'),
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey)),
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
              ),
            ),
          ],
        ),
        AnimatedOpacity(
          opacity: _isSelected[0] ? 1.0 : 0.0,
          duration: Duration(milliseconds: 250),
          child: Visibility(
            visible: _isSelected[0],
            child: Container(
              padding: EdgeInsets.only(right: screenSizeWidth * 0.05),
              child: AnimSearchBar(
                //浮動搜尋按鈕
                style: TextStyle(color: Colors.white),
                color: Theme.of(context).primaryColor,
                rtl: true,
                helpText: '輸入名稱或編號...',
                width: screenSizeWidth * 0.8,
                textController: _textEditingController,
                onSuffixTap: () {
                  _textEditingController.clear();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
