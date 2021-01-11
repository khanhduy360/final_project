import 'package:flutter/material.dart';

import 'colors_constant.dart';
import 'font_constant.dart';
import 'utils.dart';

var kInputTextDecoration = InputDecoration(
  alignLabelWithHint: true,
  errorStyle: TextStyle(
    color: Colors.red,
    wordSpacing: 5.0,
  ),
  labelStyle: TextStyle(
    fontFamily: kFontMontserrat,
    letterSpacing: 1,
    color: kColorGrey,
    fontSize: 16,
  ),
  hintStyle: TextStyle(
      letterSpacing: 1.3,
      color: Color(0xffC0C0C0),
      fontFamily: kFontMontserrat,
      fontSize: setFontSize(size: 18)),
  contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 15),
  border: InputBorder.none,
  hintText: '',
);
