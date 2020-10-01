import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_green/link.dart';
import 'package:flutter_green/src/helpers/TextStyle.dart';
import 'package:flutter_green/src/helpers/colors_constant.dart';
import 'package:flutter_green/src/helpers/screen.dart';
import 'package:flutter_green/src/helpers/shared_preferrence.dart';
import 'package:flutter_green/src/helpers/utils.dart';
import 'package:flutter_green/src/model/product.dart';
import 'package:flutter_green/src/widgets/button_raised.dart';
import 'package:flutter_green/src/widgets/card_cart_product.dart';

import 'checkout_view.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  StreamController _streamController = new StreamController();
  StreamController _productController = new StreamController();
  List<Product> productInfoList = [];
  List<CartProductCard> uiProductList = [];
  int totalPrice = 0;
  String totalPriceText = '';
  String uidUser = '';

  void dispose() {
    super.dispose();
    _productController.close();
  }

  //TODO: Delete product
  void onDelete(String productID) {
    // TODO: find Product widget
    var find = uiProductList.firstWhere((it) => it.id == productID,
        orElse: () => null);
    if (find != null) {
      Firestore.instance
          .collection('Carts')
          .document(uidUser)
          .collection(uidUser)
          .document(productID)
          .delete();
      setState(() {
        uiProductList.removeAt(uiProductList.indexOf(find));
      });
    } else {
      print(('Close faild'));
    }
    // TODO: find Product Info
    var findProInfo = productInfoList.firstWhere((it) => it.id == productID,
        orElse: () => null);
    if (findProInfo != null) {
      productInfoList.removeAt(productInfoList.indexOf(findProInfo));
      getTotal();
    }
  }

//TODO: Update new quantity
  void onChangeQty(String qty, String productID) {
    var find = productInfoList.firstWhere((it) => it.id == productID,
        orElse: () => null);
    if (find != null) {
      int index = productInfoList.indexOf(find);
      productInfoList.elementAt(index).quantity = qty;
      Firestore.instance
          .collection('Carts')
          .document(uidUser)
          .collection(uidUser)
          .document(productInfoList.elementAt(index).id)
          .updateData({'quantity': qty});
      getTotal();
    }
  }

//TODO: get total
  void getTotal() {
    totalPrice = 0;
    for (var product in productInfoList) {
      int price = (product.salePrice == '0')
          ? int.parse(product.price)
          : int.parse(product.salePrice);
      totalPrice += (price * int.parse(product.quantity));
    }
    setState(() {
      totalPriceText = Util.intToMoneyType(totalPrice);
    });
  }

//TODO: get product quantity Server
  void getQuantity() {
    for (var product in productInfoList) {
      Firestore.instance
          .collection('Products')
          .document(product.id)
          .get()
          .then((document) {
        product.quantityMain = document['quantity'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUid().then((uid) {
      _streamController.add(uid);
      uidUser = uid;
      //TODO: count item
      Firestore.instance
          .collection('Carts')
          .document(uid)
          .collection(uid)
          .getDocuments()
          .then((onValue) {
        int index = 0;
        //TODO:Get list product
        for (var value in onValue.documents) {
          print('Sale: ' + value.data['sale_price']);
          Product product = new Product(
            id: value.data['id'],
            productName: value.data['name'],
            image: value.data['image'],
            category: value.data['categogy'],
            size: value.data['size'],
            color: value.data['color'],
            price: value.data['price'],
            salePrice: value.data['sale_price'],
            brand: value.data['brand'],
            madeIn: value.data['made_in'],
            quantity: value.data['quantity'],
          );
          productInfoList.add(product);
          getQuantity();
        }
        // TODO: add list product widget
        uiProductList = productInfoList.map((product) {
          return CartProductCard(
            id: product.id,
            productName: product.productName,
            productPrice: int.parse(product.price),
            productSalePrice: int.parse(product.salePrice),
            productColor: Color(product.color),
            productSize: product.size,
            productImage: product.image,
            brand: product.brand,
            madeIn: product.madeIn,
            quantity: product.quantity,
            //TODO: onQtyChange
            onQtyChange: (qty) {
              print(qty);
              setState(() {
                product.quantity = qty;
              });
              onChangeQty(qty, product.id);
            },
            onClose: () {
              onDelete(product.id);
            },
          );
        }).toList();
        //TODO: update Item count
        setState(() {
          uiProductList.length;
        });
        getTotal();
        _productController.sink.add(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: kColorWhite,
        // TODO: Quantity Items
        title: Text(
          uiProductList.length.toString() + ' items',
          style: TextStyle(
              color: kColorBlack,
              fontSize: FontSize.setTextSize(32),
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshotMain) {
          if (snapshotMain.hasData) {
            //TODO: Load list cart product
            return StreamBuilder(
              stream: _productController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (uiProductList.length != 0) {
                    return ListView.builder(
                        itemCount: uiProductList.length,
                        itemBuilder: (_, index) => uiProductList[index]);
                  } else {
                    return Container(
                      width: ConstScreen.setSizeWidth(700),
                      height: ConstScreen.setSizeHeight(1000),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: ConstScreen.setSizeHeight(350),
                            left: ConstScreen.setSizeWidth(140),
                            child: Container(
                              width: ConstScreen.setSizeWidth(480),
                              height: ConstScreen.setSizeHeight(250),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      KImageAddress + 'noItemsCart.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: ConstScreen.setSizeHeight(650),
                            left: ConstScreen.setSizeWidth(250),
                            child: Text(
                              'No Product Order',
                              style: kBoldTextStyle.copyWith(
                                  color: kColorBlack.withOpacity(0.8),
                                  fontSize: FontSize.s36,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: kColorBlack.withOpacity(0.5), width: 1),
          ),
        ),
        height: ConstScreen.setSizeHeight(200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // TODO: Total price
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ConstScreen.setSizeHeight(5),
                    horizontal: ConstScreen.setSizeWidth(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: ConstScreen.setSizeHeight(15),
                      horizontal: ConstScreen.setSizeWidth(20)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: AutoSizeText(
                          'Total',
                          style: TextStyle(
                              fontSize: FontSize.s36,
                              fontWeight: FontWeight.bold),
                          minFontSize: 15,
                        ),
                      ),
                      // TODO: Total Price Value
                      Expanded(
                        flex: 5,
                        child: AutoSizeText(
                          totalPriceText + ' VND',
                          style: TextStyle(
                              fontSize: FontSize.setTextSize(45),
                              fontWeight: FontWeight.bold),
                          minFontSize: 15,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //TODO: Purchase button
            Expanded(
              flex: 1,
              child: CusRaisedButton(
                title: 'PLACE THIS ORDER',
                backgroundColor: kColorBlack,
                height: ConstScreen.setSizeHeight(150),
                onPress: () {
                  if (totalPrice != 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProcessingOrderView(
                          productList: productInfoList,
                          total: totalPrice,
                          uid: uidUser,
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
