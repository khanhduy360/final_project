import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';

class DashboardCard extends StatelessWidget {
  DashboardCard(
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
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ConstScreen.setSizeWidth(15),
          vertical: ConstScreen.setSizeHeight(15)),
      child: Container(
        height: ConstScreen.setSizeHeight(180),
        child: RaisedButton(
          //TODO: Navigator
          onPressed: () {
            onPress();
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: kColorWhite,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ConstScreen.setSizeWidth(20),
                vertical: ConstScreen.setSizeHeight(15)),
            child: Row(
              children: <Widget>[
                // TODO: Revenue
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText(
                        title,
                        style: kBoldTextStyle.copyWith(
                            fontSize: FontSize.s36, color: color),
                        maxLines: 1,
                        minFontSize: 20,
                      ),
                      SizedBox(
                        height: ConstScreen.setSizeHeight(10),
                      ),
                      //TODO: Revenue
                      AutoSizeText(
                        value,
                        style: kBoldTextStyle.copyWith(
                            fontSize: FontSize.setTextSize(50)),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: ConstScreen.setSizeWidth(20),
                ),
                //TODO: Icon
                Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ConstScreen.setSizeHeight(18)),
                        child: Icon(
                          icon,
                          color: kColorWhite,
                          size: ConstScreen.setSizeHeight(40),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
