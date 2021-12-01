import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;
    var developerCircleSize = screenSizeWidth * 0.1125;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: screenSizeHeight * 0.02,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(2.0, 2.0), //陰影y軸偏移量
                    blurRadius: 0, //陰影模糊程度
                    spreadRadius: 0 //陰影擴散程度
                    )
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: screenSizeWidth * 0.05),
            padding: EdgeInsets.all(screenSizeWidth * 0.05),
            child: Column(
              children: [
                Text(
                  '開發者',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
                SizedBox(
                  height: screenSizeHeight * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: [
                        CircleAvatar(
                            radius: developerCircleSize,
                            backgroundImage: NetworkImage(
                                'https://niu.ouo.tw/AboutUsImage/Peter.jpg')),
                        SizedBox(
                          height: screenSizeHeight * 0.01,
                        ),
                        Text(
                          '章沛倫',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text('資工系'),
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                            radius: developerCircleSize,
                            backgroundImage: NetworkImage(
                                'https://niu.ouo.tw/AboutUsImage/Shao.jpg')),
                        SizedBox(
                          height: screenSizeHeight * 0.01,
                        ),
                        Text(
                          '呂紹誠',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text('資工系'),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSizeHeight * 0.005,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: [
                        CircleAvatar(
                            radius: developerCircleSize,
                            backgroundImage: NetworkImage(
                                'https://niu.ouo.tw/AboutUsImage/Ken.jpg')),
                        SizedBox(
                          height: screenSizeHeight * 0.01,
                        ),
                        Text(
                          '周楷崴',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text('資工系'),
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                            radius: developerCircleSize,
                            backgroundImage: NetworkImage(
                                'https://niu.ouo.tw/AboutUsImage/David.jpg')),
                        SizedBox(
                          height: screenSizeHeight * 0.01,
                        ),
                        Text(
                          '賴宥蓁',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text('資工系'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenSizeHeight * 0.02,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    // color: Colors.grey,
                    offset: Offset(2.0, 2.0), //陰影y軸偏移量
                    blurRadius: 0, //陰影模糊程度
                    spreadRadius: 0 //陰影擴散程度
                    )
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: screenSizeWidth * 0.05),
            padding: EdgeInsets.all(screenSizeWidth * 0.05),
            child: Column(
              children: [
                Text(
                  '指導老師',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(
                          height: screenSizeHeight * 0.015,
                        ),
                        CircleAvatar(
                            radius: screenSizeWidth * 0.15,
                            backgroundImage: NetworkImage(
                                'https://niu.ouo.tw/AboutUsImage/chhuang.jpg')),
                        SizedBox(
                          height: screenSizeHeight * 0.015,
                        ),
                        Text(
                          '黃朝曦',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text('資訊工程學系 副教授'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenSizeHeight * 0.02,
          ),
        ],
      ),
    );
  }
}
