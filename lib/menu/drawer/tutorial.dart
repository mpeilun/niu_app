import 'package:flutter/material.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:provider/provider.dart';

class Tutorial {
  Tutorial(
      {required this.icon,
      required this.title,
      required this.content,
      required this.onTap});

  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onTap;
}

class TutorialPage extends StatefulWidget {
  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  List<Tutorial> tutorials = [
    Tutorial(
      icon: MenuIcon.icon_eschool,
      title: '數位學習園區',
      content: '在手機上快速地檢視課程',
      onTap: () {},
    ),
    Tutorial(
      icon: MenuIcon.icon_grades,
      title: '成績查詢',
      content: '對自己的成績一目瞭然',
      onTap: () {},
    ),
    Tutorial(
      icon: MenuIcon.icon_timetable,
      title: '每週課表',
      content: '掌握每一門課程',
      onTap: () {},
    ),
    Tutorial(
      icon: MenuIcon.icon_event,
      title: '活動報名',
      content: '隨時隨地報名參與活動',
      onTap: () {},
    ),
    Tutorial(
      icon: MenuIcon.icon_graduation,
      title: '畢業門檻',
      content: '深入了解自己的畢業資格',
      onTap: () {},
    ),
    Tutorial(
      icon: MenuIcon.icon_e_school,
      title: '選課系統',
      content: 'Coming Soon',
      onTap: () {},
    ),
    Tutorial(
      icon: MenuIcon.icon_bus,
      title: '公車動態',
      content: '輕鬆查看宜大的即時大眾運輸資訊',
      onTap: () {},
    ),
    Tutorial(
      icon: MenuIcon.icon_zuvio,
      title: 'Zuvio',
      content: '上課點名、繳交作業的好助手',
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return ListView.separated(
      controller: _scrollController,
      itemCount: tutorials.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0.0,
        thickness: 1.5,
        indent: screenSizeWidth * 0.025 + 100,
        endIndent: screenSizeWidth * 0.025,
      ),
      itemBuilder: (BuildContext context, int index) => TutorialItem(
        icon: tutorials[index].icon,
        title: tutorials[index].title,
        content: tutorials[index].content,
        onTap: tutorials[index].onTap,
      ),
    );
  }
}

class TutorialItem extends StatelessWidget {
  const TutorialItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.content,
      required this.onTap,})
      : super(key: key);
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: onTap,
      focusColor: Colors.grey.shade500,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: screenSizeWidth * 0.025,
            horizontal: screenSizeWidth * 0.025),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: themeChange.darkTheme
                    ? Theme.of(context).cardColor
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: EdgeInsets.all(10.0),
              child: RadiantGradientMask(
                child: Icon(
                  icon,
                  size: 70.0,
                ),
              ),
            ),
            SizedBox(
              width: screenSizeWidth * 0.05,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(content),
              ],
            ),
            Expanded(
                child: Container(
              child: Icon(
                Icons.keyboard_arrow_right,
                color: themeChange.darkTheme
                    ? Color(0xe0ffffff)
                    : Colors.grey.shade600,
              ),
              alignment: Alignment.centerRight,
            ))
          ],
        ),
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.bottomLeft,
          radius: 0.5,
          colors: themeChange.darkTheme?<Color>[Colors.white,Colors.white]:<Color>[Colors.pink, Colors.blue],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
