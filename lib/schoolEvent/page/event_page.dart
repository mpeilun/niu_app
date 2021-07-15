import 'package:flutter/material.dart';
import 'package:niu_app/schoolEvent/custom_cards.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) => CustomEventCard(
    key: PageStorageKey<String>('event'),
    grade: grades2,
  );
}
