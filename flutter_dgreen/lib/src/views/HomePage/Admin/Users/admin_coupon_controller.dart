import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/model/coupon.dart';

class CouponController {
  StreamController discountController = new StreamController.broadcast();
  StreamController billingAmountController = new StreamController.broadcast();
  StreamController expiredDateController = new StreamController.broadcast();

  Stream get discountStream => discountController.stream;
  Stream get billingAmountStream => billingAmountController.stream;
  Stream get expiredDateStream => expiredDateController.stream;

  Sink get expiredDateSink => expiredDateController.sink;

  onCreateCoupon(@required Coupon coupon) {
    discountController.sink.add('');
    billingAmountController.sink.add('');
    expiredDateController.sink.add('');
    int countErr = 0;

    print(coupon.discount);
    print(coupon.maxBillingAmount);
    print(coupon.expiredDate);
    if (coupon.discount == null ||
        coupon.discount == '' ||
        int.parse(coupon.discount) > 100) {
      countErr++;
      discountController.sink.addError('Invalid discount');
    }

    if (coupon.maxBillingAmount == null || coupon.maxBillingAmount == '') {
      countErr++;
      billingAmountController.sink.addError('Invalid billing amount');
    }

    if (coupon.expiredDate == null) {
      countErr++;
      expiredDateController.sink.addError('Expired date is empty.');
    }

    //TODO: Create coupon
    if (countErr == 0) {
      Firestore.instance
          .collection('Coupon')
          .document()
          .setData(coupon.toJson());
    }

    return countErr;
  }

  void dispose() {
    discountController.close();
    billingAmountController.close();
    expiredDateController.close();
  }
}
