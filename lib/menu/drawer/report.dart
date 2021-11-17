import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/components/toast.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  final List<Widget> myTabs = [
    CustomTabBar(title: '招募新血', icon: Icons.group_add),
    CustomTabBar(title: '意見回饋', icon: Icons.chat_bubble),
    CustomTabBar(title: 'BUG回報', icon: Icons.bug_report),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
    );
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(
            child: PreferredSize(
              preferredSize: Size.fromHeight(56.0),
              child: Container(
                color: Theme.of(context).primaryColor,
                height: 56.0,
                child: TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.zero,
                  indicatorWeight: 5.0,
                  tabs: myTabs,
                ),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          PageRecruit(),
          PageFeedback(),
          PageBugReport(),
        ],
      ),
    );
  }
}

class PageRecruit extends StatefulWidget {
  PageRecruit({Key? key}) : super(key: key);

  @override
  _PageRecruit createState() => _PageRecruit();
}

class _PageRecruit extends State<PageRecruit> {
  bool _checkboxSelected = false;
  String _contact = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '       很高興您對我們的App感興趣，無論是想參與功能的構想、對美術設計有大膽創新想法、或是想幫助我們持續維護APP，亦或是單純對APP開發感興趣，但不知如何下手，我們都歡迎您的加入，請留下您的Mail、Line、Discord等聯繫方式，我們將與你聯繫！',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: TextFormField(
                            initialValue: '',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              border: OutlineInputBorder(),
                              labelText: '聯繫方式',
                              hintText: '請輸入Mail、LINE等聯絡方式',
                            ),
                            onChanged: (text) {
                              _contact = text;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(children: [
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 10,
                            height: 10,
                            child: Checkbox(
                                value: _checkboxSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _checkboxSelected = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '同意送出時，在資料上標記您的學號與姓名',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          )
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () async {
                      if (_contact != '' && _checkboxSelected != false) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        Response response;
                        BaseOptions options = new BaseOptions(
                          baseUrl: "https://docs.google.com",
                          connectTimeout: 6000,
                          receiveTimeout: 3000,
                        );
                        Dio dio = new Dio(options);

                        FormData formData = new FormData.fromMap({
                          'entry.1816632315': prefs.getString('name'),
                          'entry.142380187': prefs.getString('id'),
                          'entry.172291072': _contact,
                        });

                        try {
                          response = await dio.post(
                              "/forms/d/e/1FAIpQLSdZ5n35T-dU7pDvRNBAGET8H3Ms9yYHz21tZS4tmQkHkNkL8w/formResponse",
                              data: formData);
                          showToast('成功送出！');
                        } catch (e) {
                          print('Error: $e');
                        }
                      } else if (_contact == '') {
                        showToast('聯繫方式不能為空！');
                      } else {
                        showToast('為了方便與您聯繫，請同意送出您的學號與姓名！');
                      }
                    },
                    child: Text(
                      '送出',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PageFeedback extends StatefulWidget {
  PageFeedback({Key? key}) : super(key: key);

  @override
  _PageFeedback createState() => _PageFeedback();
}

class _PageFeedback extends State<PageFeedback> {
  bool _checkboxSelected = false;
  String _contact = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '       無論是對介面設計有想法，或是需要而外的功能，都可以告訴我們，使APP持續改進，最後感謝您願意點入此頁面，提供寶貴的意見。',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: TextFormField(
                            initialValue: '',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              border: OutlineInputBorder(),
                              labelText: '意見',
                              hintText: '文字',
                            ),
                            onChanged: (text) {
                              _contact = text;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(children: [
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 10,
                            height: 10,
                            child: Checkbox(
                                value: _checkboxSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _checkboxSelected = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '以記名方式送出',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          )
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () async {
                      if (_contact != '') {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        Response response;
                        BaseOptions options = new BaseOptions(
                          baseUrl: "https://docs.google.com",
                          connectTimeout: 6000,
                          receiveTimeout: 3000,
                        );
                        Dio dio = new Dio(options);

                        String name = '匿名';
                        String id = '';
                        if (_checkboxSelected) {
                          name = prefs.getString('name')!;
                          id = prefs.getString('id')!;
                        }

                        FormData formData = new FormData.fromMap({
                          'entry.1433399447': name,
                          'entry.1949243152': id,
                          'entry.180726658': _contact,
                        });

                        try {
                          response = await dio.post(
                              "/forms/d/e/1FAIpQLSfxIvpXwmJEedPyxBxLFpkQy6REAQxeMJrXr4aYOx5ggjfBZw/formResponse",
                              data: formData);
                          showToast('成功送出！');
                        } catch (e) {
                          print('Error: $e');
                        }
                      } else {
                        showToast('內容不能為空！');
                      }
                    },
                    child: Text(
                      '送出',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PageBugReport extends StatefulWidget {
  PageBugReport({Key? key}) : super(key: key);

  @override
  _PageBugReport createState() => _PageBugReport();
}

class _PageBugReport extends State<PageBugReport> {
  bool _canReproducible = true;
  bool _checkboxSelected = false;
  String _contact = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '       無論是對介面設計有想法，或是需要而外的功能，都可以告訴我們，使APP持續改進，最後感謝您願意點入此頁面，提供寶貴的意見。',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 300,
                      child: Row(children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: Checkbox(
                              value: _canReproducible,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  _canReproducible = true;
                                });
                              }),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '可再現',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: Checkbox(
                              value: !_canReproducible,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  _canReproducible = false;
                                });
                              }),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '不可再現',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        )
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      children: [
                        Center(
                          child: TextFormField(
                            initialValue: '',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              border: OutlineInputBorder(),
                              labelText: 'BUG問題',
                              hintText: '文字',
                            ),
                            onChanged: (text) {
                              _contact = text;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(children: [
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 10,
                            height: 10,
                            child: Checkbox(
                                value: _checkboxSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _checkboxSelected = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '同意傳送設備資訊',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          )
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () async {
                      if (_contact != '' && _checkboxSelected != false) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        Response response;
                        BaseOptions options = new BaseOptions(
                          baseUrl: "https://docs.google.com",
                          connectTimeout: 6000,
                          receiveTimeout: 3000,
                        );
                        Dio dio = new Dio(options);
                        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                        if (Platform.isAndroid) {
                          AndroidDeviceInfo android =
                              await deviceInfo.androidInfo;

                          print(android.version);
                        } else if (Platform.isIOS) {
                          IosDeviceInfo ios = await deviceInfo.iosInfo;
                        }

                        FormData formData = new FormData.fromMap({
                          'entry.664827657': _canReproducible.toString(), //可否再現
                          'entry.1169887801': _contact, //內容
                          'entry.1770154643': _contact, //系統
                          'entry.240297325': _contact, //系統版本
                          'entry.155630872': _contact, //app版本
                        });

                        try {
                          response = await dio.post(
                              "/forms/d/e/1FAIpQLSefdKU911s_ONEtuBDLLaA_YnfzEHF2pHFpUHfxT12VxDESoA/formResponse",
                              data: formData);
                          showToast('成功送出！');
                        } catch (e) {
                          print('Error: $e');
                        }
                      } else if (_contact != '') {
                        showToast('內容不能為空！');
                      } else {
                        showToast('請同意傳送設備資訊，以便我們修正錯誤');
                      }
                    },
                    child: Text(
                      '送出',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
