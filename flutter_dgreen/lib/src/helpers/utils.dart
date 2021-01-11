import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';

class Util {
  static String intToMoneyType(int value) {
    var controller = MoneyMaskedTextController(
        initialValue: value.toDouble(),
        precision: 0,
        decimalSeparator: '',
        thousandSeparator: ',');
    return controller.text;
  }

  static String convertDateToFullString(String dateTime) {
    DateTime value = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
    var formatter = new DateFormat.yMd().add_jm();
    return formatter.format(value);
  }

  static String convertDateToString(String dateTime) {
    DateTime value = new DateFormat("yyyy-MM-dd").parse(dateTime);
    var formatter = new DateFormat.yMd();
    return formatter.format(value);
  }

  static String convertDateAndHourToString(String dateTime) {
    DateTime value = new DateFormat("yyyy-MM-dd hh:mm").parse(dateTime);
    var formatter = new DateFormat('hh:mm dd/MM/yyyy');
    return formatter.format(value);
  }

  static String encodePassword(String password) {
    var bytes = utf8.encode(password);
    return sha512.convert(bytes).toString();
  }

  static bool isDateGreaterThanNow(String dateTime) {
    DateTime date = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
    return (date.millisecondsSinceEpoch >
        DateTime.now().millisecondsSinceEpoch);
  }
}

setFontSize({double size}) {
  return ScreenUtil().setSp(size);
}

setHeightSize({double size}) {
  return ScreenUtil().setHeight(size);
}

getScreenWidth() {
  return ScreenUtil.screenWidthDp;
}

setWidthSize({double size}) {
  return ScreenUtil().setWidth(size);
}

convertDate({String date}) {
  var now = DateTime.parse(date);
  var formatter = new DateFormat('dd/MM/yyyy');
  String formatted = formatter.format(now);
  return formatted; // something like 2013-04-20
}

convertTime(String date) {
  var now = DateTime.parse(date);
  var formatter = new DateFormat('hh:mm');
  String formatted = formatter.format(now);
  return formatted;
}

formatCurrency(int value) {
  if (value != null) {
    final formatCurrency =
        new NumberFormat.simpleCurrency(decimalDigits: 0, locale: 'vi');
    return formatCurrency.format(value);
  } else {
    return 0;
  }
}
