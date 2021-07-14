import 'package:flutter/material.dart';
import 'package:niu_app/Components/circle.dart';

class CustomIcons extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback press;
  const CustomIcons({
    Key? key, required this.title, required this.icon, required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: CustomPaint(
            painter: CirclePainter(),
            child: IconButton(
              iconSize: 40,
              icon: Icon(icon, color: Colors.black),
              onPressed: press,
            ),
          ),
        ),
        SizedBox(height: 2.0,),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}


class CustomTabBar extends StatelessWidget {
  final String title;
  final IconData icon;
  const CustomTabBar({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Tab(
              icon: Icon(icon),
            ),
          ),
          SizedBox(width: 3.0,),
          Flexible(flex: 3, child: Text(title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),)),
        ],
      ),
    );
  }
}
class CGWIcon extends StatelessWidget {
  const CGWIcon({
    Key? key,
    required this.isWarnList,
    required this.title,
    required this.icon,
    required this.index,
  }) : super(key: key);

  final List isWarnList;
  final String title;
  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          width: 35.0,
          height: 35.0,
          child: isWarnList[index]
              ? Icon(
            icon,
            color: Colors.red,
            size: 30.0,
          )
              : null,
          decoration: BoxDecoration(
            border: isWarnList[index] ? null : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
        )
      ],
    );
  }
}