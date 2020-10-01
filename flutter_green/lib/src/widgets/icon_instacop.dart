import 'package:flutter/material.dart';

class IconInstacop extends StatelessWidget {
  IconInstacop({this.textSize});
  final double textSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'D',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'GREEN',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w900,
            color: Colors.greenAccent.shade200,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
