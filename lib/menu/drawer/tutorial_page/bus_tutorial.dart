import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:niu_app/school_event/components/custom_list_info.dart';
import 'package:provider/provider.dart';

class BusTutorialPage extends StatefulWidget {
  const BusTutorialPage({Key? key}) : super(key: key);

  @override
  _BusTutorialPageState createState() => _BusTutorialPageState();
}

class _BusTutorialPageState extends State<BusTutorialPage> {
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
        title: '公車動態',
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
              themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: '在這個頁面可以輕鬆取得所有經過宜大的公車路線，點擊其中之一即可查看即時資訊。',
        marginDescription:
            EdgeInsets.fromLTRB(20.0, screenSizeHeight * 0.05, 20.0, .0),
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/bus/bus_black.png"
            : "assets/tutorial/bus/bus_white.png",
        heightImage: 300.0,
      ),
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: '公車動態',
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight * 0.025),
        styleTitle: TextStyle(
          color:
              themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: '這個頁面可以查看該條路線的即時動態、票價、時刻表與路線簡圖。',
        marginDescription:
            EdgeInsets.fromLTRB(20.0, screenSizeHeight * 0.05, 20.0, .0),
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/bus/bus2_black.png"
            : "assets/tutorial/bus/bus2_white.png",
        heightImage: 300.0,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('公車動態'),
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
