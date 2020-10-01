import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_green/src/helpers/colors_constant.dart';
import 'package:flutter_green/src/helpers/screen.dart';
import 'package:flutter_green/src/helpers/utils.dart';

class ProductCard extends StatelessWidget {
  ProductCard(
      {@required this.productName,
      this.id = '',
      @required this.price,
      @required this.image,
      this.salePrice = 0,
      this.isIconClose = false,
      this.isSoldOut = false,
      this.onClosePress,
      this.onTap});

  final String id;
  final String productName;
  final String image;
  final int price;
  final int salePrice;
  final bool isIconClose;
  final Function onTap;
  final Function onClosePress;
  final bool isSoldOut;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kColorLightGrey),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // TODO: Product Image
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    height: ConstScreen.setSizeHeight(5),
                  ),
                  //TODO: Product Name
                  AutoSizeText(
                    productName,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: FontSize.s24,
                        color: kColorBlack,
                        fontWeight: FontWeight.w400),
                    minFontSize: 15,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  //TODO: Product Price
                  AutoSizeText(
                    Util.intToMoneyType(price) + ' VND',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: FontSize.s24,
                        color: kColorBlack,
                        decoration: (salePrice != 0)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                    minFontSize: 5,
                    textAlign: TextAlign.center,
                  ),
                  //TODO: Sale Price
                  (salePrice != 0)
                      ? AutoSizeText(
                          Util.intToMoneyType(salePrice) + ' VND',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: FontSize.s24,
                            color: kColorRed,
                          ),
                          minFontSize: 5,
                          textAlign: TextAlign.center,
                        )
                      : Text(' '),
                ],
              ),
              isIconClose
                  ? Positioned(
                      left: ConstScreen.setSizeWidth(250),
                      top: ConstScreen.setSizeWidth(-20),
                      child: IconButton(
                        onPressed: () {
                          onClosePress();
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              color: kColorWhite),
                          child: Icon(
                            Icons.close,
                            size: ConstScreen.setSizeWidth(30),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              isSoldOut
                  ? Positioned(
                      top: ConstScreen.setSizeHeight(45),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Transform.rotate(
                          angle: -math.pi / 4,
                          child: Container(
                            color: kColorBlack.withOpacity(0.8),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: ConstScreen.setSizeHeight(5),
                                  horizontal: ConstScreen.setSizeHeight(10)),
                              child: AutoSizeText(
                                'SOLD OUT',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: FontSize.s27,
                                    color: kColorRed,
                                    fontWeight: FontWeight.w900),
                                minFontSize: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
