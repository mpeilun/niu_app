import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:niu_app/school_event/components/custom_list_info.dart';
import 'package:provider/provider.dart';

class GradeTutorialPage extends StatefulWidget {
  const GradeTutorialPage({Key? key}) : super(key: key);

  @override
  _GradeTutorialPageState createState() => _GradeTutorialPageState();
}

class _GradeTutorialPageState extends State<GradeTutorialPage> {
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
    List<Slide> slides = [
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "期中成績",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
              themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description:
            "成績查訊系統，在教師上傳成績至學校學務系統後，顯示課程成績。點選上方功能條，可切換「期中成績」、「期末成績」、「期中預警」。",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/grade/gradeMid_black.png"
            : "assets/tutorial/grade/gradeMid_white.png",
        heightImage: 300.0,
        marginDescription: EdgeInsets.fromLTRB(
            20.0, screenSizeHeight * 0.05, 20.0, screenSizeHeight * 0.05),
      ),
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "期末成績",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
              themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "顯示期末成績與排名，排名需要等待，所有課程都有成績資訊才會顯示！",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/grade/gradeFin_black.png"
            : "assets/tutorial/grade/gradeFin_white.png",
        heightImage: 300.0,
        marginDescription: EdgeInsets.fromLTRB(
            20.0, screenSizeHeight * 0.05, 20.0, screenSizeHeight * 0.05),
      ),
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "學期預警",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
              themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "顯示各課程的期中預警情況，並凸顯各課程預警細項。",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/grade/gradeWarm_black.png"
            : "assets/tutorial/grade/gradeWarm_white.png",
        heightImage: 300.0,
        marginDescription: EdgeInsets.fromLTRB(
            20.0, screenSizeHeight * 0.05, 20.0, screenSizeHeight * 0.05),
      ),
    ];

    Color? iconColor = Theme.of(context).iconTheme.color;
    return Scaffold(
      appBar: AppBar(
        title: Text('成績查詢'),
      ),
      body: SafeArea(
        child: new IntroSlider(
          showSkipBtn: false,
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
          colorDot: Colors.grey,
          sizeDot: 10,
          typeDotAnimation: DotSliderAnimation.SIZE_TRANSITION,

          // Tabs
          // listCustomTabs: this.renderListCustomTabs(),
          slides: slides,

          // Behavior
          scrollPhysics: BouncingScrollPhysics(),

          // On tab change completed
          onTabChangeCompleted: this.onTabChangeCompleted,
        ),
      ),
    );
  }
}
