import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:niu_app/school_event/components/custom_list_info.dart';
import 'package:provider/provider.dart';

class ESchoolTutorialPage extends StatefulWidget {
  const ESchoolTutorialPage({Key? key}) : super(key: key);

  @override
  _ESchoolTutorialPageState createState() => _ESchoolTutorialPageState();
}

class _ESchoolTutorialPageState extends State<ESchoolTutorialPage> {
  late var screenSizeWidth = MediaQuery.of(context).size.width;
  late var screenSizeHeight = MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
  }

  void onDonePress() {
    Navigator.pop(context);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
    print(index);
  }

  ButtonStyle myButtonStyle() {
    return (Theme.of(context).elevatedButtonTheme.style) as ButtonStyle;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    List<ContentConfig> slides = [
      ContentConfig(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "我的課程",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
          themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "進入數位學習園區即可一覽所有我的課程，點即展開更多課程資訊，包含「課程公告」、「開始上課」、「成績資訊」。",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/e_school/lesson_black.png"
            : "assets/tutorial/e_school/lesson_white.png",
        heightImage: 300.0,
        marginDescription: EdgeInsets.fromLTRB(
            20.0, screenSizeHeight * 0.05, 20.0, screenSizeHeight * 0.05),
      ),
      ContentConfig(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "我的作業",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
          themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "一次查看目前課程有的「所有作業」，點擊「查看」進入該課程查看詳細作業事項，同時可以繳交或下載作業。",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/e_school/work_black.png"
            : "assets/tutorial/e_school/work_white.png",
        heightImage: 300.0,
        marginDescription: EdgeInsets.fromLTRB(
            20.0, screenSizeHeight * 0.05, 20.0, screenSizeHeight * 0.05),
      ),
      ContentConfig(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "課程公告",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
          themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "點擊課程中的「課程公告」，進入數位學習園區中的課程布告欄。",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/e_school/announcement_black.png"
            : "assets/tutorial/e_school/announcement_white.png",
        heightImage: 300.0,
        marginDescription:
        EdgeInsets.fromLTRB(20.0, screenSizeHeight * 0.05, 20.0, .0),
      ),
      ContentConfig(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "開始上課",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
          themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "點擊課程中的「開始上課」，進入該課程列表，點開每個節點查看課程內容，點擊「進入教材」開始下載教材或進入影片內容。",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/e_school/class_black.png"
            : "assets/tutorial/e_school/class_white.png",
        heightImage: 300.0,
        marginDescription: EdgeInsets.fromLTRB(
            20.0, screenSizeHeight * 0.05, 20.0, screenSizeHeight * 0.05),
      ),
      ContentConfig(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "成績資訊",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
          themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "點擊課程中的「成績資訊」，進入數位學習園區，成績資訊類別查看成績。",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/e_school/grade_black.png"
            : "assets/tutorial/e_school/grade_white.png",
        heightImage: 300.0,
        marginDescription: EdgeInsets.fromLTRB(
            20.0, screenSizeHeight * 0.05, 20.0, screenSizeHeight * 0.05),
      ),
    ];

    Color? iconColor = Theme.of(context).iconTheme.color;
    return Scaffold(
      appBar: AppBar(
        title: Text('數位學習園區'),
      ),
      body: SafeArea(
        child: new IntroSlider(
          isShowSkipBtn: false,
          // Prev button
          renderPrevBtn: Icon(
            Icons.navigate_before,
            color: iconColor,
            size: 20.0,
          ),
          prevButtonStyle: myButtonStyle(),

          // Next button
          renderNextBtn: Icon(
            Icons.navigate_next,
            color: iconColor,
            size: 20.0,
          ),
          nextButtonStyle: myButtonStyle(),

          // Done button
          renderDoneBtn: Icon(
            Icons.done,
            color: iconColor,
            size: 20.0,
          ),
          onDonePress: this.onDonePress,
          doneButtonStyle: myButtonStyle(),

          // Dot indicator
          indicatorConfig: IndicatorConfig(
              colorIndicator: Colors.grey,
              sizeIndicator: 10,
              typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition
          ),

          // Tabs
          // listCustomTabs: this.renderListCustomTabs(),
          listContentConfig: slides,

          // Behavior
          scrollPhysics: BouncingScrollPhysics(),

          // On tab change completed
          onTabChangeCompleted: this.onTabChangeCompleted,
        ),
      ),
    );
  }
}
