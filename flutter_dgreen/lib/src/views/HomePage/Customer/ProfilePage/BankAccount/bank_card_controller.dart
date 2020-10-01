import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';

class BankCardController {
  StreamController _btnLoadController = new StreamController();
  StreamController _uidController = new StreamController();

  Stream get btnLoadStream => _btnLoadController.stream;
  Stream get uidStream => _uidController.stream;

  Sink get uidSink => _uidController.sink;

  void dispose() {
    _btnLoadController.close();
    _uidController.close();
  }

  onAdd({
    String cardNumber,
    String expiryDate,
    String cardHolderName,
    String cvvCode,
  }) async {
    int expYear;
    int expMonth;

    print(cardNumber.length);
    if (cardNumber == '' || cardNumber == null || cardNumber.length != 16) {
      return 'Invalid Card Number.';
    }

    if (expiryDate == '' || expiryDate == null || expiryDate.length != 5) {
      return 'Invalid Expired Date.';
    } else {
      var expiryArr = expiryDate.split('/');
      expMonth = int.parse(expiryArr[0]);
      expYear = int.parse(expiryArr[1]);
      int monthNow = DateTime.now().month;
      int yearNow = DateTime.now().year.toInt() % 2000;
      if (expMonth < 0 ||
          expMonth > 13 ||
          (expMonth < monthNow && expYear == yearNow)) {
        return 'Invalid Expired Month.';
      }
      if (expYear < yearNow) {
        return 'Invalid Expired Year.';
      }
    }

    if (cvvCode == null || cvvCode == '' || cvvCode.length < 2) {
      return 'Invalid CVV';
    }

    if (cardHolderName == null || cardHolderName == '') {
      return 'Invalid Card Holder';
    }

    try {
      _btnLoadController.sink.add(false);
      String uid = await StorageUtil.getUid();
      await Firestore.instance
          .collection('Cards')
          .document(DateTime.now().millisecondsSinceEpoch.toString())
          .setData({
        'uid': uid,
        'cardNumber': cardNumber,
        'expiryMonth': expMonth,
        'expiryYear': expYear,
        'cardHolderName': cardHolderName,
        'cvvCode': cvvCode
      });
      _btnLoadController.sink.add(true);
      return 'true';
    } catch (err) {
      return 'Error';
    }
  }
}
