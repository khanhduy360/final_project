import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';

class DashboardBox extends StatelessWidget {
  DashboardBox(
      {this.title = '',
      this.value = '',
      this.icon = Icons.title,
      this.color = kColorWhite,
      this.onPress});

  final String title;
  final IconData icon;
  final String value;
  final Color color;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: ConstScreen.setSizeHeight(160),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ConstScreen.setSizeWidth(10),
        ),
        child: RaisedButton(
          onPressed: () {
            onPress();
          },
          color: kColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ConstScreen.setSizeWidth(5),
                vertical: ConstScreen.setSizeHeight(5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //TODO: icon
                      Icon(
                        icon,
                        size: ConstScreen.setSizeHeight(30),
                        color: color,
                      ),
                      SizedBox(
                        width: ConstScreen.setSizeWidth(20),
                      ),
                      //TODO: Title
                      AutoSizeText(
                        title,
                        style: kBoldTextStyle.copyWith(
                            fontSize: FontSize.s36, color: color),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ],
                  ),
                ),
                // TODO: Value
                Expanded(
                  flex: 5,
                  child: Center(
                    child: AutoSizeText(
                      value,
                      style: kBoldTextStyle.copyWith(
                          fontSize: FontSize.setTextSize(55),
                          color: kColorBlack.withOpacity(0.75)),
                      maxLines: 1,
                      minFontSize: 10,
                    ),
                  ),
                ),
                SizedBox(
                  height: ConstScreen.setSizeHeight(15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
