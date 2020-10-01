import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';

class CategoryItem extends StatelessWidget {
  CategoryItem({this.title, this.onTap, this.height = 80});

  final String title;
  final Function onTap;
  final double height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: ConstScreen.setSizeHeight(height),
        width: ConstScreen.setSizeWidth(760),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: kColorBlack.withOpacity(0.1),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: ConstScreen.setSizeHeight(25),
              left: ConstScreen.setSizeWidth(50)),
          child: Text(
            title,
            style: TextStyle(fontSize: FontSize.s30),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
