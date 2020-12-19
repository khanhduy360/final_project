import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';

class TreePickingList {
  //TODO: list color
  static const List<String> ColorList = [
    'Black',
    'White',
    'Grey',
    'Red',
    'Blue',
    'Yellow',
    'Orange',
    'Pink',
    'Brown',
    'Purple',
    'Cyan',
    'Green'
  ];

//TODO: Convert ColorList value to Color
  Color getColorFromColorList(String value) {
    switch (value) {
      case 'Black':
        return kColorBlack;
      case 'White':
        return kColorWhite;
      case 'Grey':
        return kColorGrey;
      case 'Red':
        return kColorRed;
      case 'Blue':
        return kColorBlue;
      case 'Yellow':
        return kColorYellow;
      case 'Orange':
        return kColorOrange;
      case 'Pink':
        return kColorPink;
      case 'Brown':
        return kColorBrown;
      case 'Purple':
        return kColorPurple;
      case 'Cyan':
        return kColorCyan;
      case 'Green':
        return kColorGreen;
      default:
        return kColorWhite;
    }
  }
}
