import 'package:flutter/material.dart';
import 'package:niu_app/schoolEvent/custom_cards.dart';

class EventSignedPage extends StatefulWidget {
  const EventSignedPage({Key? key}) : super(key: key);

  @override
  _EventSignedPageState createState() => _EventSignedPageState();
}

class _EventSignedPageState extends State<EventSignedPage> {
  @override
  Widget build(BuildContext context) => CustomEventSignedCard(
    key: PageStorageKey<String>('eventSigned'),
    grade: grades2,
  );
}
