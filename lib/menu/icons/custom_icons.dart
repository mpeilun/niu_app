import 'package:flutter/material.dart';
import 'package:niu_app/Components/circle.dart';

class CustomIcons extends StatelessWidget {
  final String text;
  final IconData icons;
  final VoidCallback press;
  const CustomIcons({
    Key? key, required this.text, required this.icons, required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: CustomPaint(
            painter: CirclePainter(),
            child: IconButton(
              iconSize: 40,
              icon: Icon(icons, color: Colors.black),
              onPressed: press,
            ),
          ),
        ),
        SizedBox(height: 3.0,),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
