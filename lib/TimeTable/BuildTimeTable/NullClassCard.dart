import 'package:flutter/material.dart';

class NullClassCard extends StatelessWidget {
  const NullClassCard.build();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11),  //2*5課表+1時間
      child: Text(""),
    );
  }

}

