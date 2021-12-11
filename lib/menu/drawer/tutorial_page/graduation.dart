import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:niu_app/provider/dark_mode_provider.dart';
import 'package:niu_app/school_event/components/custom_list_info.dart';
import 'package:provider/provider.dart';

class GraduationTourPage extends StatefulWidget {
  const GraduationTourPage({Key? key}) : super(key: key);

  @override
  _GraduationTourPageState createState() => _GraduationTourPageState();
}

class _GraduationTourPageState extends State<GraduationTourPage> {
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
        title: "多元時數",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight*0.025),
        styleTitle: TextStyle(
          color: themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "圖形化顯示，在校之多元時數，想了解時數登記的完整細項，可點選右方「詳細」查看。",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/graduation/graduation_black.png"
            : "assets/tutorial/graduation/graduation_white.png",
        heightImage: 300.0,
      ),
      Slide(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "各類門檻",
        marginTitle: EdgeInsets.symmetric(vertical: screenSizeHeight*0.025),
        styleTitle: TextStyle(
          color: themeChange.darkTheme ? Colors.blue.shade200 : Colors.blue[900],
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "顯示畢業所需的各類門檻目標，快速掌握通過狀態",
        styleDescription: TextStyle(
          color: themeChange.darkTheme ? Color(0xffffffff) : Colors.black,
          fontSize: 20.0,
        ),
        pathImage: themeChange.darkTheme
            ? "assets/tutorial/graduation/graduation2_black.png"
            : "assets/tutorial/graduation/graduation2_white.png",
        heightImage: 300.0,
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
