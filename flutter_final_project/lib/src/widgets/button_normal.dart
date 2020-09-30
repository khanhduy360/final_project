import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'box-loading.dart';

class ButtonNormal extends StatelessWidget {
  const ButtonNormal({
    @required this.text,
    this.onPress,
    this.color = Colors.white,
    this.isDisableClick = false,
    this.isBtnColor = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.hasSuffixIcon = false,
  });

  final String text;
  final Color color;

  final Function onPress;
  final bool isLoading;
  final bool isDisableClick;
  final bool isBtnColor;
  final bool hasSuffixIcon;
  final Icon prefixIcon;
  final Icon suffixIcon;

  @override
  Widget build(BuildContext context) {
    Color btnColor = color != Colors.white ? color : Colors.white;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: (isDisableClick || isLoading) ? 0.5 : 1,
          child: Container(
            padding: EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              gradient: color == Colors.white
                  ? LinearGradient(
                      colors: [Color(0xFF69F0AE), Color(0xFF4CAF50)],
                      tileMode: TileMode
                          .mirror, // repeats the gradient over the canvas
                    )
                  : null,
            ),
            child: MaterialButton(
              color: isBtnColor ? Colors.transparent : btnColor,
              elevation: 0,
              onPressed: () {
                if (!isDisableClick && !isLoading) {
                  onPress();
                }
              },
              minWidth: double.infinity,
              height: 50.0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  prefixIcon != null ? prefixIcon : Container(),
                  SizedBox(width: 5),
                  Text(
                    text,
                    style: TextStyle(
                      color: isBtnColor || color != Colors.white
                          ? Colors.white
                          : kColorGreen,
                      fontSize: setFontSize(size: 16.0),
                    ),
                  ),
                  SizedBox(width: hasSuffixIcon != null ? 15 : 0),
                  suffixIcon != null || hasSuffixIcon
                      ? Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: setFontSize(size: 14),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        isLoading
            ? Positioned(left: 20, top: 13, child: BoxLoading(size: 30))
            : Container()
      ],
    );
  }
}
