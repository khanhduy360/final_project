import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';

class TitleWidget extends StatelessWidget {
  TitleWidget({this.title = '', this.content = '', this.isSpaceBetween = true});

  final String title;
  final String content;
  final bool isSpaceBetween;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ConstScreen.setSizeHeight(10),
          horizontal: ConstScreen.setSizeWidth(25)),
      child: Row(
        mainAxisAlignment: isSpaceBetween
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: AutoSizeText(
              title,
              maxLines: 1,
              minFontSize: 10,
              style: kBoldTextStyle.copyWith(
                  fontSize: FontSize.s30, color: kColorBlack.withOpacity(0.6)),
            ),
          ),
          Expanded(
            flex: 7,
            child: AutoSizeText(
              content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              style: kBoldTextStyle.copyWith(
                  fontSize: FontSize.setTextSize(31), color: kColorBlack),
            ),
          ),
        ],
      ),
    );
  }
}
