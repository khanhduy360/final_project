import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';

class CusRaisedButton extends StatefulWidget {
  CusRaisedButton(
      {this.backgroundColor,
      @required this.title,
      this.onPress,
      this.width = 710,
      this.height = 80,
      this.isDisablePress = true});

  final Color backgroundColor;
  final String title;
  final Function onPress;
  final double width;
  final double height;
  final bool isDisablePress;
  @override
  _CusRaisedButtonState createState() => _CusRaisedButtonState();
}

class _CusRaisedButtonState extends State<CusRaisedButton> {
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return MaterialButton(
      height: ConstScreen.setSizeHeight(widget.height),
      minWidth: ConstScreen.setSizeHeight(widget.width),
      color: widget.backgroundColor,
      child: widget.isDisablePress
          ? Text(
              widget.title,
              style: TextStyle(
                  fontSize: FontSize.s27,
                  color: (widget.backgroundColor == kColorBlue)
                      ? kColorWhite
                      : kColorGreen),
            )
          : CircularProgressIndicator(
              backgroundColor: kColorWhite,
            ),
      onPressed: () {
        if (widget.isDisablePress) {
          widget.onPress();
        }
      },
    );
  }
}
