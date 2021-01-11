import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/helpers/validator.dart';
import 'package:flutter_dgreen/src/model/coupon.dart';
import 'package:flutter_dgreen/src/model/product.dart';
import 'package:flutter_dgreen/src/model/quantityOrder.dart';

class CheckoutController {
  StreamController _nameStreamController = new StreamController();
  StreamController _phoneStreamController = new StreamController();
  StreamController _addressStreamController = new StreamController();
  StreamController _quantityStreamController = new StreamController();
  StreamController _btnStreamController = new StreamController();

  Stream get nameStream => _nameStreamController.stream;
  Stream get phoneStream => _phoneStreamController.stream;
  Stream get addressStream => _addressStreamController.stream;
  Stream get quantityStream => _quantityStreamController.stream;
  Stream get btnLoadingStream => _btnStreamController.stream;
  Validators validators = new Validators();
  onPayment({
    @required String name,
    @required String phoneNumber,
    @required String address,
    @required List<Product> productList,
    @required String total,
    @required String orderId,
    @required String clientSecret,
    @required String paymentMethodId,
    String discountPrice,
    Coupon coupon,
  }) async {
//   TODO: Payment
    try {
      String cusName = await StorageUtil.geFullName();
      String uid = await StorageUtil.getUid();
      //TODO: receiver info
      await FirebaseFirestore.instance.collection('Orders').doc(orderId).set({
        'id': uid,
        'sub_Id': orderId,
        'customer_name': cusName,
        'receiver_name': name,
        'address': address,
        'discountPrice': discountPrice,
        'total': total,
        'phone': phoneNumber,
        'status': 'Pending',
        'client_secret': clientSecret,
        'payment_method_id': paymentMethodId,
        'month': DateTime.now().month,
        'year': DateTime.now().year,
        'create_at': DateTime.now().toString(),
        'couponId': (coupon.id != null && coupon.id != '') ? coupon.id : '',
        'discount': (coupon.discount != null && coupon.discount != '')
            ? coupon.discount
            : '0',
        'billingAmount':
            (coupon.maxBillingAmount != null && coupon.maxBillingAmount != '')
                ? coupon.maxBillingAmount
                : '0',
        'shipping': (int.parse(total) >= 300000) ? '0' : '20000'
      }).then((value) {
        //TODO: add list product
        for (var product in productList) {
          FirebaseFirestore.instance
            ..collection('Orders')
                .doc(orderId)
                .collection(uid)
                .doc(product.id)
                .set({
              'id': product.id,
              'name': product.productName,
              'color': product.color,
              'price': (int.parse(product.salePrice) == 0)
                  ? product.price
                  : product.salePrice,
              'quantity': product.quantity,
              'quantityMain': product.quantityMain,
            });
        }
      });

      //TODO: decrease quantity
      List<QuantityOrder> quantityOrderList = [];
      for (var product in productList) {
        QuantityOrder quantityOrder = new QuantityOrder(
            productId: product.id, quantity: int.parse(product.quantity));
        quantityOrderList.add(quantityOrder);

        for (var qtyOrder in quantityOrderList) {
          FirebaseFirestore.instance
              .collection('Products')
              .doc(qtyOrder.productId)
              .get()
              .then((document) {
            int quantity = int.parse(document.data()['quantity']);
            int result = quantity - qtyOrder.quantity;
            FirebaseFirestore.instance
                .collection('Products')
                .doc(qtyOrder.productId)
                .update({'quantity': result.toString()});
          });
        }
      }

      FirebaseFirestore.instance
          .collection('Carts')
          .doc(uid)
          .collection(uid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot document in snapshot.docs) {
          document.reference.delete();
        }
      });
    } catch (err) {
      return false;
    }
    return true;
  }

  onValidate({
    @required String name,
    @required String phoneNumber,
    @required String address,
    @required List<Product> productList,
    @required String total,
  }) async {
    _btnStreamController.add(false);
    _nameStreamController.sink.add('');
    _phoneStreamController.sink.add('');
    _addressStreamController.sink.add('');
    _quantityStreamController.add('');
    int countError = 0;
    String message = 'Too much quantity selected: \n';
    if (name == null || name == '') {
      _nameStreamController.sink.addError('Người nhận không được trống.');
      countError++;
    }

    if (phoneNumber == null ||
        phoneNumber == '' ||
        (phoneNumber.length < 10 || phoneNumber.length > 11)) {
      _phoneStreamController.sink.addError('Số điện thoại không đúng.');
      countError++;
    }

    if (address == null || address == '') {
      _addressStreamController.sink.addError('Địa chỉ không được để trống.');
      countError++;
    }

    //TODO: Check quantity maximum
    for (var product in productList) {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(product.id)
          .get()
          .then((document) {
        if (int.parse(product.quantity) > int.parse(product.quantityMain)) {
          countError++;
          message +=
              '+  ${product.quantity}/${product.quantityMain} quantity of  ${product.productName} product \n';
        }
      });
    }
    _btnStreamController.add(true);
    if (countError == 0) {
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    _nameStreamController.close();
    _phoneStreamController.close();
    _addressStreamController.close();
    _quantityStreamController.close();
  }
}
