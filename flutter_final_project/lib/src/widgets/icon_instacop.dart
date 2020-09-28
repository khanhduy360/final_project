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
          'Insta',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'COP',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w900,
            color: Colors.redAccent.shade700,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
