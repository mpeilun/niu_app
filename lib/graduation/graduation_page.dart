import 'package:flutter/material.dart';
import 'package:niu_app/graduation/graduation_hour.dart';
import 'package:niu_app/graduation/time.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'graduation_detail.dart';

class GraduationPage extends StatefulWidget {
  final Time time;
  final Pass pass;

  const GraduationPage({Key? key, required this.time, required this.pass})
      : super(key: key);

  @override
  _GraduationPageState createState() => _GraduationPageState();
}

class _GraduationPageState extends State<GraduationPage> {
  final passWord = ['通過', '尚未檢測', '未通過'];

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final passColor = [
      themeChange.darkTheme ? Colors.green[300] : Colors.green[600],
      themeChange.darkTheme ? Colors.white : Colors.black,
      Colors.red
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('畢業門檻'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GraduationDetail(),
                        maintainState: false));
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                minimumSize: Size(0.0, 0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
              ),
              child: Text(
                '查詢畢業門檻',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 20.0),
                child: Column(
                  children: [
                    CustomCard(
                      title: '多元時數',
                      rowChild: Tooltip(
                        showDuration: Duration(milliseconds: 500),
                        message: '前往網頁查詢',
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              minimumSize: Size(0.0, 0.0),
                            ),
                            child: Text("詳細",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GraduationHour(),
                                      maintainState: false));
                            }),
                      ),
                      columnChild: SizedBox()
                      // FittedBox(
                      //   fit: BoxFit.scaleDown,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Indicator(
                      //         title: '服務奉獻',
                      //         time: widget.time.service.split('/')[0],
                      //         requiredTime: double.parse(
                      //             widget.time.service.split('/')[1]),
                      //       ),
                      //       SizedBox(
                      //         width: 20.0,
                      //       ),
                      //       Indicator(
                      //         title: '多元成長',
                      //         time: widget.time.multiple.split('/')[0],
                      //         requiredTime: double.parse(
                      //             widget.time.multiple.split('/')[1]),
                      //       ),
                      //       SizedBox(
                      //         width: 20.0,
                      //       ),
                      //       Indicator(
                      //         title: '專業進取',
                      //         time: widget.time.profession.split('/')[0],
                      //         requiredTime: double.parse(
                      //             widget.time.profession.split('/')[1]),
                      //       ),
                      //       SizedBox(
                      //         width: 20.0,
                      //       ),
                      //       Indicator(
                      //         title: '彈性綜合',
                      //         time: widget.time.flex.split('/')[0],
                      //         requiredTime:
                      //             double.parse(widget.time.flex.split('/')[1]),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomCard(
                        title: '英語能力',
                        rowChild: Text(
                          passWord[widget.pass.english],
                          style: TextStyle(
                              fontSize: 16.0,
                              color: passColor[widget.pass.english]),
                        ),
                        columnChild: SizedBox()),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomCard(
                        title: '體適能',
                        rowChild: Text(
                          passWord[widget.pass.physical],
                          style: TextStyle(
                            fontSize: 16.0,
                            color: passColor[widget.pass.physical],
                          ),
                        ),
                        columnChild: SizedBox()),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomCard(
                        title: '應修學分總數',
                        rowChild: Text(
                          widget.pass.credit,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        columnChild: SizedBox()),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomCard(
                        title: '學分學程',
                        rowChild: Text(
                          widget.pass.program,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        columnChild: SizedBox())
                  ],
                ),
              )),
        );
      }),
    );
  }
}

class Indicator extends StatelessWidget {
  final String title;
  final String time;
  final double requiredTime;

  const Indicator({
    Key? key,
    required this.title,
    required this.time,
    required this.requiredTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    double times = double.parse('$time');
    return Container(
      child: CircularPercentIndicator(
          header: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ),
          animation: true,
          animationDuration: 750,
          radius: 100.0,
          lineWidth: 10.0,
          percent: times / requiredTime,
          center: Text(
            "$time/${requiredTime.toStringAsFixed(0)}",
            style: TextStyle(
                fontSize: 16.0,
                color:
                    themeChange.darkTheme ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.grey,
          progressColor:
              themeChange.darkTheme ? const Color(0xff212121) : Colors.blue),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final Widget rowChild;
  final Widget columnChild;

  const CustomCard(
      {Key? key,
      required this.title,
      required this.rowChild,
      required this.columnChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                rowChild,
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            columnChild,
          ],
        ),
      ),
    );
  }
}
