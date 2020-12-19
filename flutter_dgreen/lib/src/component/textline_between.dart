import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';

import 'size_box_component.dart';

class TextLineBetween extends StatelessWidget {
  final String label;
  final String content;
  final TextStyle labelStyle;
  final TextStyle contentStyle;
  final CrossAxisAlignment crossAxisAlignment;

  const TextLineBetween({
    Key key,
    this.label = '',
    this.content = '',
    this.labelStyle,
    this.contentStyle,
    this.crossAxisAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('$label: ', style: kBoldTextStyle),
            Expanded(
              child: Text(
                content,
                style: contentStyle,
                textAlign: TextAlign.right,
              ),
            )
          ],
        ),
        SizeBoxHeight(size: 30)
      ],
    );
  }
}
