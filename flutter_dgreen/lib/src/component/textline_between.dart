import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';

import 'size_box_component.dart';

class TextLineBetween extends StatelessWidget {
  final String label;
  final String content;
  final TextStyle labelStyle;
  final TextStyle contentStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final Function onContentTap;

  const TextLineBetween({
    Key key,
    this.label = '',
    this.content = '',
    this.labelStyle,
    this.contentStyle,
    this.onContentTap,
    this.crossAxisAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      color: Color(0xFF2D2D2D),
      fontSize: setFontSize(size: 30),
      height: setHeightSize(size: 1.8),
    );
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('$label: ', style: labelStyle ?? defaultStyle),
            Expanded(
              child: GestureDetector(
                onTap: onContentTap,
                child: Text(
                  content,
                  style: contentStyle ??
                      defaultStyle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
            )
          ],
        ),
        SizeBoxHeight(size: 30)
      ],
    );
  }
}
