import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:niu_app/school_event/components/custom_list_info.dart';
import 'package:provider/provider.dart';

class TimeTableTutorialPage extends StatefulWidget {
  const TimeTableTutorialPage({Key? key}) : super(key: key);

  @override
  _TimeTableTutorialPageState createState() => _TimeTableTutorialPageState();
}

class _TimeTableTutorialPageState extends State<TimeTableTutorialPage> {
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
        title: "週週課表",
        marginTitle: const EdgeInsets.symmetric(vertical: 24.0),
        styleTitle: TextStyle(
          color: themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "以週次為單位的簡潔課表，點擊課表上的節次，可切換顯示節次時間，並且配合備註功能可在每週的課堂上記錄重要事項哦！",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/timetable/timetable_black.png"
            : "assets/tutorial/timetable/timetable_white.png",
        heightImage: 300.0,
      ),
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "重要事項",
        marginTitle: const EdgeInsets.symmetric(vertical: 24.0),
        styleTitle: TextStyle(
          color: themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description:
            "點即需紀錄的課程，可填寫此課堂的重要事項，完成後課表會有紅框提醒，如需要完成的截止日，不在本週，可在右上角，點選週次，切換課表。",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/timetable/timetableSce_black.png"
            : "assets/tutorial/timetable/timetableSce_white.png",
        heightImage: 300.0,
      ),
    ];

    Color? iconColor = Theme.of(context).iconTheme.color;
    return Scaffold(
      appBar: AppBar(
        title: Text('課表'),
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
          typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

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
