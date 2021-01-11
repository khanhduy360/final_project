import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';

class TreePickingList {
  //TODO: list color
  static const List<String> ColorList = [
    'Trắng',
    'Đỏ',
    'Xanh dương',
    'Vàng',
    'Cam',
    'Hồng',
    'Nâu',
    'Tím',
    'Xanh lá'
  ];

//TODO: Convert ColorList value to Color
  Color getColorFromColorList(String value) {
    switch (value) {
      case 'Trắng':
        return kColorWhite;
      case 'Đỏ':
        return kColorRed;
      case 'Xanh dương':
        return kColorBlue;
      case 'Vàng':
        return kColorYellow;
      case 'Cam':
        return kColorOrange;
      case 'Hồng':
        return kColorPink;
      case 'Nâu':
        return kColorBrown;
      case 'Tím':
        return kColorPurple;
      case 'Xanh lá':
        return kColorGreen;
      default:
        return kColorWhite;
    }
  }
}
