import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final int value;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.value,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: FontSize.s30,
                  fontWeight: FontWeight.bold,
                  color: textColor),
            )
          ],
        ),
        Text(
          'Total: $value',
          style: TextStyle(
              fontSize: FontSize.s27,
              fontWeight: FontWeight.normal,
              color: textColor),
        )
      ],
    );
  }
}
