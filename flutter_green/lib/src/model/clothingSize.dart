import 'package:flutter/material.dart';
import 'package:flutter_green/src/helpers/colors_constant.dart';

class ClothingPickingList {
  // TODO: Tee size
  static const List<String> TeeSize = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'XXXL'
  ];

  //TODO: Pant size
  static const List<String> PantSize = [
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36'
  ];

//TODO: Shoes size
  static const List<String> ShoesSize = [
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
  ];

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
