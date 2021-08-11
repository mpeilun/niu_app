//棄用
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  Calendar({
    required this.index,
  });
  int index;
  @override
  _Calendar createState() => _Calendar();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _Calendar extends State<Calendar>{
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String name = "";
    String detail = "";
    String indexString;
    if(widget.index == 1)
      indexString = "考試";
    else if(widget.index == 2)
      indexString = "報告";
    else
      indexString = "作業";
    return Scaffold(
      appBar: AppBar(
        title: const Text('行事曆'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: <Widget> [
              //週次不知要不要
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '名稱',
                    hintText: '清輸入名稱',
                  ),
                  onChanged: (text) {
                    name = text;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '範圍',
                    hintText: "清輸入" + indexString + "範圍",
                  ),
                  onChanged: (text) {
                    detail = text;
                  },
                )
              ),

            ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(name + detail),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.add),
      ),
    );
  }
}