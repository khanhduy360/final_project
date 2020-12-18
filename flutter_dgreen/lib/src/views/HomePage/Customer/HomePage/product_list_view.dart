import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/link.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/model/product.dart';
import 'package:flutter_dgreen/src/widgets/card_product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ProductDetail/main_detail_product_view.dart';

class ProductListView extends StatefulWidget {
  ProductListView({this.search});
  final String search;
  @override
  _DetailBannerScreenState createState() => _DetailBannerScreenState();
}

class _DetailBannerScreenState extends State<ProductListView> {
  bool isSearch = false;
  bool isSale = false;
  String title = '';
  getFirestoreSnapshot() {
    if (widget.search == 'sale') {
      setState(() {
        title = 'Giảm giá';
      });
      return FirebaseFirestore.instance
          .collection('Products')
          .where('sale_price', isGreaterThan: '0')
          .snapshots();
    } else if (widget.search != '') {
      setState(() {
        title = 'Đang tìm';
      });
      return FirebaseFirestore.instance
          .collection('Products')
          .orderBy('create_at')
          .where('categogy', isEqualTo: widget.search)
          .snapshots();
    } else {
      setState(() {
        title = 'Mới nhập';
      });
      return FirebaseFirestore.instance
          .collection('Products')
          .orderBy('create_at')
          .snapshots();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.search == 'sale') {
      setState(() {
        title = 'Khuyến mãi';
      });
    } else if (widget.search != '') {
      setState(() {
        title = 'Tìm kiếm';
      });
    } else {
      setState(() {
        title = 'Mới nhập';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppBar(
          iconTheme: IconThemeData.fallback(),
          backgroundColor: kColorWhite,
          centerTitle: true,
          title: Text(
            title,
            style: kBoldTextStyle.copyWith(
                fontSize: FontSize.s36, color: kColorGreen),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.shoppingBag,
                color: kColorGreen,
              ),
              onPressed: () {
                StorageUtil.getIsLogging().then((bool value) {
                  if (value != null) {
                    Navigator.pushNamed(context, 'customer_cart_page');
                  } else {
                    Navigator.pushNamed(context, 'register_screen');
                  }
                });
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: ConstScreen.setSizeHeight(40),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: ConstScreen.setSizeHeight(30),
                right: ConstScreen.setSizeHeight(30),
                bottom: ConstScreen.setSizeHeight(30),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: getFirestoreSnapshot(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
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
                                        KImageAddress + 'noSearchResult.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: ConstScreen.setSizeHeight(650),
                              left: ConstScreen.setSizeWidth(160),
                              child: Text(
                                'Sorry, No Search Result',
                                style: kBoldTextStyle.copyWith(
                                    color: kColorBlack.withOpacity(0.8),
                                    fontSize: FontSize.s36,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return GridView.count(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        crossAxisSpacing: ConstScreen.setSizeHeight(30),
                        mainAxisSpacing: ConstScreen.setSizeHeight(40),
                        childAspectRatio: 66 / 110,
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return ProductCard(
                            productName: document['name'],
                            image: document['image'][0],
                            isSoldOut: (document['quantity'] == '0'),
                            price: int.parse(document['price']),
                            salePrice: (document['sale_price'] != '0')
                                ? int.parse(document['sale_price'])
                                : 0,
                            onTap: () {
                              Product product = new Product(
                                id: document['id'],
                                productName: document['name'],
                                imageList: document['image'],
                                category: document['categogy'],
                                colorList: document['color'],
                                price: document['price'],
                                salePrice: document['sale_price'],
                                brand: document['brand'],
                                madeIn: document['made_in'],
                                quantityMain: document['quantity'],
                                quantity: '',
                                description: document['description'],
                                rating: document['rating'],
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
                          );
                        }).toList(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
