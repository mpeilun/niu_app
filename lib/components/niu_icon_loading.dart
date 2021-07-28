import 'package:flutter/material.dart';
import 'dart:math';

class NiuIconLoading extends StatefulWidget {
  final size;

  const NiuIconLoading({Key? key, required double this.size}) : super(key: key);

  @override
  _NiuIconLoadingState createState() => _NiuIconLoadingState();
}

class _NiuIconLoadingState extends State<NiuIconLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 2500), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * pi,
                child: child,
              );
            },
            child: Image.asset('assets/ic_launcher_round.png'),
          ),
        ),
      ),
    );
  }
}