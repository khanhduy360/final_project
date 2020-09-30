import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/image_constant.dart';

class BoxLoading extends StatefulWidget {
  BoxLoading({this.size = 120});
  final double size;
  @override
  _BoxLoadingState createState() => _BoxLoadingState();
}

class _BoxLoadingState extends State<BoxLoading>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
    );
    animationController.forward();
    animationController.addListener(() {
      setState(() {
        if (animationController.status == AnimationStatus.completed) {
          animationController.repeat();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
      child: Image.asset(kIconLoading, width: widget.size),
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
