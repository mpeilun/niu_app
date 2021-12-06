import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:niu_app/school_event/components/custom_list_info.dart';

class TutorialPage extends StatefulWidget {
  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage>
    with SingleTickerProviderStateMixin {
  List<Slide> slides = [];
  late var screenSizeWidth = MediaQuery.of(context).size.width;
  late var screenSizeHeight = MediaQuery.of(context).size.height;
  late Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "SCHOOL",
        styleTitle: TextStyle(
          color: Color(0xff3da4ab),
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.",
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "images/photo_school.png",
      ),
    );
    slides.add(
      new Slide(
        title: "MUSEUM",
        styleTitle: TextStyle(
            color: Color(0xff3da4ab),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Ye indulgence unreserved connection alteration appearance",
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "images/photo_museum.png",
      ),
    );
    slides.add(
      new Slide(
        title: "COFFEE SHOP",
        styleTitle: TextStyle(
            color: Color(0xff3da4ab),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "images/photo_coffee_shop.png",
      ),
    );
  }

  void onDonePress() {
    // Back to the first tab
    this.goToTab(0);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
    print(index);
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(Color(0x33ffcc5c)),
      overlayColor: MaterialStateProperty.all<Color>(Color(0x33ffcc5c)),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < 5; i++) {
      // Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(screenSizeWidth * 0.05,
                    screenSizeHeight * 0.01, screenSizeWidth * 0.05, 0.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          '測試',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSizeWidth * 0.05,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          '很厲害呦',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 1.0), //陰影y軸偏移量
                        blurRadius: 0, //陰影模糊程度
                        spreadRadius: 0 //陰影擴散程度
                        )
                  ],
                ),
                margin: EdgeInsets.fromLTRB(
                    screenSizeWidth * 0.05,
                    screenSizeHeight * 0.01,
                    screenSizeWidth * 0.05,
                    screenSizeHeight * 0.01),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    accentColor: Colors.black,
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    key: PageStorageKey('tutorial'),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenSizeWidth * 0.04,
                        ),
                        Text(
                          '詳細資料',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                            height: 25.0,
                            width: 55.0,
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2.0, color: Color(0xff1E88E5)),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      10.0) //         <--- border radius here
                                  ),
                            ),
                            child: Text(
                              '報名中',
                              style: TextStyle(
                                  fontSize: 12.0, color: Color(0xff1E88E5)),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                    children: [
                      Column(
                        children: [
                          ListInfo(
                            icon: Icons.info,
                            title: '活動編號',
                            widget:
                                Text('12345', style: TextStyle(fontSize: 14)),
                          ),
                          ListInfo(
                            icon: Icons.calendar_today,
                            title: '活動時間',
                            widget: Column(
                              children: [
                                Text(
                                  '2021/11/11 11:11起',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '2021/11/11 22:22止',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          ListInfo(
                            icon: Icons.access_time,
                            title: '報名時間',
                            widget: Column(
                              children: [
                                Text(
                                  '2021/12/12 11:11111111 起',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '2021/12/12 22:22 止',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          ListInfo(
                            icon: Icons.groups,
                            title: '報名人數',
                            widget: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '正取: 0/12人',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '備取: 0/0人',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) =>
                              //       EventInfoDialog(
                              //           eventJS: display[index]
                              //               ['signUpJs']),
                              // );
                            },
                            child: Text('我要報名'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSizeHeight * 0.015,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //     child: Image.asset(
              //   'assets/ic_launcher_niu.png',
              //   width: 200.0,
              //   height: 200.0,
              //   fit: BoxFit.contain,
              // )),
              // Container(
              //   child: Text(
              //     'assets/ic_launcher_niu.png',
              //     style: currentSlide.styleTitle,
              //     textAlign: TextAlign.center,
              //   ),
              //   margin: EdgeInsets.only(top: 20.0),
              // ),
              // Container(
              //   child: Text(
              //     'currentSlide.description',
              //     style: currentSlide.styleDescription,
              //     textAlign: TextAlign.center,
              //     maxLines: 5,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              //   margin: EdgeInsets.only(top: 20.0),
              // ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: this.renderNextBtn(),
      nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: Color(0xffffcc5c),
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      // slides: slides,
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Behavior
      scrollPhysics: BouncingScrollPhysics(),

      // Show or hide status bar
      hideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}
