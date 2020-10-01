import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_green/src/helpers/shared_preferrence.dart';
import 'package:flutter_green/src/model/product.dart';

class ProductController {
  StreamController _sizeStreamController = new StreamController();
  StreamController _loveWishlistStreamController = new StreamController();

  Stream get sizeStream => _sizeStreamController.stream;
  Stream get loveWishlistStream => _loveWishlistStreamController.stream;

  //TODO: add product to cart
  addProductToCart({
    @required int color,
    @required String size,
    @required Product product,
  }) async {
    _sizeStreamController.add('');
    int countError = 0;
    if (size == null || size == '') {
      _sizeStreamController.addError('Picking your clothing size.');
      countError++;
    }
    print(countError);
    //TODO: Add Product to Your Cart
    if (countError == 0) {
      String userUid = await StorageUtil.getUid();
      print(userUid);
      await Firestore.instance
          .collection('Carts')
          .document(userUid)
          .collection(userUid)
          .document(product.id)
          .setData({
        'id': product.id,
        'name': product.productName,
        'image': product.imageList[0],
        'categogy': product.category,
        'size': size,
        'color': color,
        'price': product.price,
        'sale_price': product.salePrice,
        'brand': product.brand,
        'made_in': product.madeIn,
        'quantity': '1',
        'create_at': DateTime.now().toString()
      }).catchError((onError) {
        return false;
      });
      return true;
    }
    return null;
  }

  //TODO Add product to Wish list
  addProductToWishlist({@required Product product}) async {
    String userUid = await StorageUtil.getUid();
    await Firestore.instance
        .collection('Wishlists')
        .document(userUid)
        .collection(userUid)
        .document(product.id)
        .setData({
      'id': product.id,
      'create_at': DateTime.now().toString()
    }).catchError((onError) {
      return false;
    });
    _loveWishlistStreamController.add(true);
    return true;
  }

  void dispose() {
    _sizeStreamController.close();
    _loveWishlistStreamController.close();
  }
}
