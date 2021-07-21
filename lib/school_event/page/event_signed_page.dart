import 'package:flutter/material.dart';
import 'package:niu_app/school_event/custom_cards.dart';

class EventSignedPage extends StatefulWidget {
  const EventSignedPage({Key? key}) : super(key: key);

  @override
  _EventSignedPageState createState() => _EventSignedPageState();
}

class _EventSignedPageState extends State<EventSignedPage> {
  @override
  Widget build(BuildContext context) => CustomEventSignedCard(
        key: PageStorageKey<String>('eventSigned'),
        data: grades2,
      );
}
