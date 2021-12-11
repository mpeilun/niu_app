import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:niu_app/school_event/components/custom_list_info.dart';
import 'package:provider/provider.dart';

class ZuvioTutorialPage extends StatefulWidget {
  const ZuvioTutorialPage({Key? key}) : super(key: key);

  @override
  _ZuvioTutorialPageState createState() => _ZuvioTutorialPageState();
}

class _ZuvioTutorialPageState extends State<ZuvioTutorialPage> {
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
        title: 'Zuvio',
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight*0.025),
        styleTitle: TextStyle(
          color: themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: '進入Zuvio後可以在下方選擇學習(課程列表)、訊息、我的(個人資訊)三個分頁，在「學習」分頁中可點選欲查看的課程。',
        marginDescription: EdgeInsets.fromLTRB(20.0, screenSizeHeight*0.05, 20.0, .0),
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/zuvio/zuvio_black.png"
            : "assets/tutorial/zuvio/zuvio_white.png",
        heightImage: 300.0,
      ),
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: 'Zuvio',
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight*0.025),
        styleTitle: TextStyle(
          color: themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description:
        '進入課程後，下方有五個分頁，可以根據自己的需求進行操作，右下角房子圖案的按鈕可以回到主畫面。',
        marginDescription: EdgeInsets.fromLTRB(20.0, screenSizeHeight*0.05, 20.0, .0),
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/zuvio/zuvio2_black.png"
            : "assets/tutorial/zuvio/zuvio2_white.png",
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
