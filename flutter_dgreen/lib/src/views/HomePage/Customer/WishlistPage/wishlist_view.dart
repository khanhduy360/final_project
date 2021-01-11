import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/model/product.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/HomePage/ProductDetail/main_detail_product_view.dart';
import 'package:flutter_dgreen/src/widgets/card_product.dart';

import '../../../../../link.dart';

class WishListView extends StatefulWidget {
  @override
  _WishListViewState createState() => _WishListViewState();
}

class _WishListViewState extends State<WishListView>
    with AutomaticKeepAliveClientMixin {
  StreamController _uidStreamController = new StreamController();
  StreamController _dataStreamController = new StreamController();
  List<ProductCard> listProduct = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUid().then((uid) {
      _uidStreamController.add(uid);
      getWishlistList(uid);
    });
  }

  removeProduct(String idProduct) {
    var result =
        listProduct.firstWhere((it) => it.id == idProduct, orElse: () => null);
    if (result != null) {
      int index = listProduct.indexOf(result);
      setState(() {
        listProduct.removeAt(index);
      });
    }
  }

  Future<void> getWishlistList(String uid) async {
    List<ProductCard> list = [];
    await FirebaseFirestore.instance
        .collection('WishLists')
        .doc(uid)
        .collection(uid)
        .get()
        .then((snap) async {
      if (snap.docs != null) {
        for (var document in snap.docs) {
          var doc = await FirebaseFirestore.instance
              .collection('Products')
              .doc(document['id'])
              .get();
          listProduct.add(ProductCard(
            id: doc['id'],
            productName: doc['name'],
            image: doc['image'][0],
            isSoldOut: (doc['quantity'] == '0'),
            price: int.parse(doc['price']),
            salePrice: int.parse(doc['sale_price']),
            isIconClose: true,
            onTap: () {
              Product product = new Product(
                id: doc['id'],
                productName: doc['name'],
                imageList: doc['image'],
                category: doc['categogy'],
                colorList: doc['color'],
                price: doc['price'],
                salePrice: doc['sale_price'],
                madeIn: doc['made_in'],
                quantityMain: doc['quantity'],
                quantity: '',
                description: doc['description'],
                rating: doc['rating'],
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainDetailProductView(
                    product: product,
                  ),
                ),
              );
            },
            onClosePress: () {
              FirebaseFirestore.instance
                  .collection('WishLists')
                  .doc(uid)
                  .collection(uid)
                  .doc(doc['id'])
                  .delete();
              removeProduct(doc['id']);
            },
          ));
        }
      }

      _dataStreamController.add(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return StreamBuilder(
        stream: _uidStreamController.stream,
        builder: (context, snapshotMain) {
          if (snapshotMain.hasData) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ConstScreen.setSizeHeight(10),
                  horizontal: ConstScreen.setSizeWidth(20)),
              child: StreamBuilder(
                  stream: _dataStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (listProduct.length != 0) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 68 / 110,
                            crossAxisSpacing: ConstScreen.setSizeHeight(30),
                            mainAxisSpacing: ConstScreen.setSizeHeight(40),
                          ),
                          itemCount: listProduct.length,
                          itemBuilder: (_, index) => listProduct[index],
                        );
                      } else {
                        return Container(
                          width: ConstScreen.setSizeWidth(700),
                          height: ConstScreen.setSizeHeight(1000),
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  width: ConstScreen.setSizeWidth(374),
                                  height: ConstScreen.setSizeHeight(220),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          KImageAddress + 'emptyInbox.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: ConstScreen.setSizeHeight(680),
                                left: ConstScreen.setSizeWidth(150),
                                child: Text(
                                  'Không có sản phẩm nào',
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
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
