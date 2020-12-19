import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';

class IconNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: setWidthSize(size: 43),
      height: setWidthSize(size: 43),
      child: Center(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            GestureDetector(
              onTap: () {
//                Navigator.pop(context);
              },
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: setFontSize(size: 60),
              ),
            ),
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 1),
                height: 14,
                width: 14,
                decoration:
                    BoxDecoration(color: kColorRed, shape: BoxShape.circle),
                child: Center(
                  child: AutoSizeText(
                    '1',
                    minFontSize: 3.0,
                    style: TextStyle(
                      height: 1.2,
                      fontSize: 8,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
