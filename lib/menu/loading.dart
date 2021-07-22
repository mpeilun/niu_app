import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Image.network(
            'https://i.pinimg.com/originals/6b/67/cb/6b67cb8a166c0571c1290f205c513321.gif'),
      ),
    );
  }
}
