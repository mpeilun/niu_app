import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("About"));
  }
}