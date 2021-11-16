import 'package:flutter/material.dart';
import 'package:niu_app/menu/icons/custom_icons.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  final List<Widget> myTabs = [
    CustomTabBar(title: '招募新血', icon: Icons.check),
    CustomTabBar(title: '意見回饋', icon: Icons.check),
    CustomTabBar(title: 'BUG回報', icon: Icons.check),
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
          Text(''),
          Text(''),
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '很高興您對我們的App感興趣，無論是想參與功能的構想、對美術設計有大膽創新想法、或是想幫助我們持續維護APP，我們都歡迎您的加入，只需要有',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
                          height: 10,
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
                            width: 8,
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
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('送出'),
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
