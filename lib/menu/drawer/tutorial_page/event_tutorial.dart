import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:niu_app/school_event/components/custom_list_info.dart';
import 'package:provider/provider.dart';

class EventTutorialPage extends StatefulWidget {
  const EventTutorialPage({Key? key}) : super(key: key);

  @override
  _EventTutorialPageState createState() => _EventTutorialPageState();
}

class _EventTutorialPageState extends State<EventTutorialPage> {

  late var screenSizeWidth = MediaQuery.of(context).size.width;
  late var screenSizeHeight = MediaQuery.of(context).size.height;
  late Function goToTab;

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
    Color? iconColor = Theme.of(context).iconTheme.color;
    final themeChange = Provider.of<DarkThemeProvider>(context);
    List<Slide> slides = [
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: '活動報名',
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight*0.025),
        styleTitle: TextStyle(
          color: themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: '「活動報名」有兩個分頁，左邊是活動列表，右邊則是已報名的活動，點擊上方的分頁按鈕或是滑動螢幕即可切換頁面。',
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/event/eventCls_black.png"
            : "assets/tutorial/event/eventCls_white.png",
        heightImage: 300.0,
      ),
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: '活動報名',
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight*0.025),
        styleTitle: TextStyle(
          color: themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description:
        '此頁上方的三個按鈕為篩選器，可以根據需求檢視所需的活動；下方為活動列表，點「詳細資料」可展開此活動的時間、報名狀況等等。若要繼續報名這個活動，點擊下方「前往報名」即可進行下一步。',
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/event/eventCard_black.png"
            : "assets/tutorial/event/eventCard_white.png",
        heightImage: 300.0,
      ),
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: '活動詳細資料',
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight*0.025),
        styleTitle: TextStyle(
          color: themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description:
        '在這裡可以看到此活動的所有資訊，確認無誤後即可點選左上角的「報名」按鈕填寫資料，若想退出頁面則點擊右上角的 × 。',
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/event/eventSign_black.png"
            : "assets/tutorial/event/eventSign_white.png",
        heightImage: 300.0,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('活動報名'),
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
          refFuncGoToTab: (refFunc) {
            this.goToTab = refFunc;
          },

          // Behavior
          scrollPhysics: BouncingScrollPhysics(),

          // On tab change completed
          onTabChangeCompleted: this.onTabChangeCompleted,
        ),
      ),
    );
  }
}
