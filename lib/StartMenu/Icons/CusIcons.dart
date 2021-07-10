import 'package:flutter/material.dart';
import 'package:niu_app/Components/Circle.dart';

class CusIcons extends StatelessWidget {
  final String text;
  final IconData icons;
  final VoidCallback press;
  const CusIcons({
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
        SizedBox(height: 2),
        Text(
          text,
        ),
      ],
    );
  }
}
