import 'package:flutter/material.dart';

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
        IconButton(
          iconSize: 40,
          icon: Icon(icons, color: Colors.black),
          onPressed: press,
        ),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
