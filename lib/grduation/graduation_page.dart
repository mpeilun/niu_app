import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:niu_app/grduation/time.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Graduation extends StatefulWidget {
  const Graduation({Key? key}) : super(key: key);

  @override
  _GraduationState createState() => _GraduationState();
}

class _GraduationState extends State<Graduation> {
  final time = Time(service: '15', multiple: '20', profession: '5', flex: '14');
  final pass = Pass(english: 0, physical: 0, credit: '47/128');
  final passWord = ['通過', '尚未檢測', '未通過'];
  final passColor = [Colors.green[600], Colors.black, Colors.red];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('畢業門檻'),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  minimumSize: Size(0.0, 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),),
                  elevation: 5.0,
                ),
                child: Text('查詢畢業門檻', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
        body:LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
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
                                  style: TextStyle(fontSize: 14, color: Colors.white)),
                              onPressed: () => null),
                        ),
                        columnChild: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Indicator(
                                title: '服務奉獻',
                                time: time.service,
                                requiredTime: 20.0,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Indicator(
                                title: '多元成長',
                                time: time.multiple,
                                requiredTime: 20.0,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Indicator(
                                title: '專業進取',
                                time: time.profession,
                                requiredTime: 20.0,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Indicator(
                                title: '彈性綜合',
                                time: time.flex,
                                requiredTime: 40.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      CustomCard(
                          title: '英語能力',
                          rowChild: Text(
                            passWord[pass.english],
                            style: TextStyle(
                                fontSize: 16.0,
                                color: passColor[pass.english]),
                          ),
                          columnChild: SizedBox()),
                      SizedBox(
                        height: 20.0,
                      ),
                      CustomCard(
                          title: '體適能',
                          rowChild: Text(
                            passWord[pass.physical],
                            style: TextStyle(
                              fontSize: 16.0,
                              color: passColor[pass.physical],),
                          ),
                          columnChild: SizedBox()),
                      SizedBox(
                        height: 20.0,
                      ),
                      CustomCard(
                          title: '應修學分總數',
                          rowChild: Text(
                            pass.credit,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          columnChild: SizedBox()),
                    ],
                  ),
                ),
              ),
            );
          },
        )
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
              color: Colors.grey[600],
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.grey,
        progressColor: Colors.blue,
      ),
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
