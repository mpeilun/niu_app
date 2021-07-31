import 'package:flutter/material.dart';

class EventInfoDialog extends StatefulWidget {
  const EventInfoDialog({Key? key}) : super(key: key);

  @override
  _EventInfoDialogState createState() => _EventInfoDialogState();
}

class _EventInfoDialogState extends State<EventInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: Text('報名'),
              style: ButtonStyle(),
            ),
            Expanded(child: SizedBox()),
            IconButton(onPressed: (){}, icon: Icon(Icons.close)),
          ],
        ),
      ],
    );
  }
}
