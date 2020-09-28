import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';

class BoxInfo extends StatelessWidget {
  BoxInfo({this.sizeProduct, this.color = kColorWhite, this.size = 50});

  bool isTextBox;
  final Color color;
  final String sizeProduct;
  final double size;
  @override
  Widget build(BuildContext context) {
    if (sizeProduct == null) {
      isTextBox = false;
    } else
      isTextBox = true;
    return Container(
      height: ConstScreen.setSizeHeight(size),
      width: ConstScreen.setSizeHeight(size + 20),
      decoration: BoxDecoration(
        border: Border.all(color: kColorBlack.withOpacity(0.5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(ConstScreen.setSizeHeight(3)),
        child: Container(
          color: isTextBox ? kColorWhite : color,
          child: Center(
            child: isTextBox
                ? AutoSizeText(
                    sizeProduct,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: FontSize.s26,
                        fontWeight: FontWeight.w500,
                        color: kColorBlack),
                    minFontSize: 5,
                  )
                : Text(''),
          ),
        ),
      ),
    );
  }
}
